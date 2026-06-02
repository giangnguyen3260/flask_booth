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

  int get shotCount {
    final value =
        appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 10;
    return value <= 0 ? 10 : value;
  }

  void saveImage({required String imagePath}) {
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
          if (image == null) return;
          tImages.add(image.path);
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
          if (video == null) return;
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
    final timeout = DateTime.now().add(const Duration(seconds: 20));
    while (tImages.length != shotCount ||
        tVideos.length != shotCount ||
        tVideos.length != tImages.length) {
      if (DateTime.now().isAfter(timeout)) {
        final fallbackPath = uiImages.isNotEmpty ? uiImages.last : "";
        while (tImages.length < shotCount) {
          tImages.add(fallbackPath);
        }
        while (tVideos.length < shotCount) {
          tVideos.add(fallbackPath);
        }
        break;
      }
      await Future.delayed(Duration(seconds: 1));
    }

    for (int i = 0; i < tImages.length; i++) {
      realDataFiles[tImages[i]] = tVideos[i];
    }

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
