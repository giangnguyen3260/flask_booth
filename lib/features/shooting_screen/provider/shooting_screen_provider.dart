import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/common/util/directory_utils.dart';
import 'package:project_l/common/util/ffmpeg_utils.dart';
import 'package:project_l/features/shooting_screen/provider/shooting_screen_listen_state.dart';

@injectable
class ShootingScreenProvider extends BaseProvider<ShootingScreenListenState> {
  final FfmpegUtils _ffmpegUtils;

  ShootingScreenProvider(this._ffmpegUtils);

  Map<String, String> realDataFiles = {};
  List<String> uiImages = [];
  List<String> tImages = [];
  List<String> tVideos = [];
  bool isLoading = false;

  String? get latestPreviewImagePath =>
      uiImages.lastOrNull ?? tImages.lastOrNull;

  int get shotCount {
    final value =
        appState.imageParam.selectedFrame.frameSetting?.shortCount ??
            appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ??
            10;
    return value <= 0 ? 10 : value;
  }

  void saveImage({required String imagePath}) {
    logD(
        'Shooting saveImage: path=$imagePath exists=${File(imagePath).existsSync()}');
    uiImages.add(imagePath);
    unawaited(
      appState.sendEvent(
        eventType: "PHOTO_CAPTURED",
        payload: {
          "capturedCount": uiImages.length,
          "targetCount": shotCount,
        },
      ),
    );
    notifyListeners();
    final (double, double) size =
        appState.imageParam.selectedFrame.getInnerImageSize();
    _ffmpegUtils.preprocessShootingImage(
        imagePath: imagePath,
        width: size.$1,
        height: size.$2,
        onComplete: (image) {
          if (image == null) {
            logE('Shooting preprocess image failed: $imagePath');
            return;
          }
          logD('Shooting preprocess image done: ${image.path}');
          tImages.add(image.path);
          notifyListeners();
        });
  }

  void saveVideo({required String videoPath, required int second}) {
    final (double, double) size =
        appState.imageParam.selectedFrame.getInnerImageSize();
    _ffmpegUtils.preprocessShootingVideo(
        videoPath: videoPath,
        width: size.$1,
        height: size.$2,
        onComplete: (video) {
          if (video == null) {
            logE('Shooting preprocess video failed: $videoPath');
            return;
          }
          logD('Shooting preprocess video done: ${video.path}');
          tVideos.add(video.path);
        },
        second: second);
  }

  Future<void> saveMockCapture({
    required String imagePath,
    String? videoPath,
  }) async {
    final sourceFile = File(imagePath);
    if (!sourceFile.existsSync()) {
      final assetBytes =
          (await rootBundle.load('KHUNG TRƠN TRẮNG/demo_layout.jpg'))
              .buffer
              .asUint8List();
      await sourceFile.writeAsBytes(assetBytes);
    }

    final captureIndex = uiImages.length + 1;
    final folder = await DirectoryUtils.documentDirectory(
      parentFolder: 'mock_capture',
    );
    final uniquePath = path.join(
      folder,
      'mock_capture_${appState.imageParam.session}_$captureIndex.jpg',
    );
    await sourceFile.copy(uniquePath);
    var resolvedVideoPath = uniquePath;
    if (videoPath != null && videoPath.isNotEmpty) {
      final sourceVideoFile = File(videoPath);
      if (sourceVideoFile.existsSync()) {
        final extension = path.extension(videoPath).isEmpty
            ? '.mp4'
            : path.extension(videoPath);
        resolvedVideoPath = path.join(
          folder,
          'mock_capture_${appState.imageParam.session}_$captureIndex$extension',
        );
        await sourceVideoFile.copy(resolvedVideoPath);
      }
    }

    uiImages.add(uniquePath);
    tImages.add(uniquePath);
    tVideos.add(resolvedVideoPath);
    unawaited(
      appState.sendEvent(
        eventType: "PHOTO_CAPTURED",
        payload: {
          "capturedCount": uiImages.length,
          "targetCount": shotCount,
          "cameraMode": "mock",
        },
      ),
    );
    notifyListeners();
  }

  void onNextEvent() async {
    isLoading = true;
    notifyListeners();
    final timeout = DateTime.now().add(const Duration(seconds: 90));
    while (tImages.length != shotCount ||
        tVideos.length != shotCount ||
        tVideos.length != tImages.length) {
      if (DateTime.now().isAfter(timeout)) {
        while (tImages.length < shotCount) {
          final index = tImages.length;
          final fallbackPath =
              index < uiImages.length ? uiImages[index] : uiImages.lastOrNull;
          tImages.add(fallbackPath ?? "");
        }
        while (tVideos.length < shotCount) {
          final index = tVideos.length;
          final fallbackPath =
              index < uiImages.length ? uiImages[index] : uiImages.lastOrNull;
          tVideos.add(fallbackPath ?? "");
        }
        break;
      }
      await Future.delayed(Duration(seconds: 1));
    }

    final orderedImages = [...tImages]..sort();
    final orderedVideos = [...tVideos]..sort();
    for (int i = 0; i < orderedImages.length; i++) {
      realDataFiles[orderedImages[i]] = orderedVideos[i];
    }
    logD('Shooting onNext files: ${realDataFiles.keys.toList()}');

    streamController.sink.add(ShootingScreenSuccessState());
    unawaited(
      appState.sendEvent(
        eventType: "SHOOTING_COMPLETED",
        payload: {
          "capturedCount": uiImages.length,
          "targetCount": shotCount,
        },
      ),
    );
  }
}
