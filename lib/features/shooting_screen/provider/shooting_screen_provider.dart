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

  int _acceptedCaptureCount = 0;

  bool get hasPendingReview => uiImages.length > _acceptedCaptureCount;

  int get acceptedCaptureCount => _acceptedCaptureCount;

  int get shotCount {
    final value = appState.imageParam.selectedFrame.frameSetting?.shortCount ??
        appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ??
        10;
    return value <= 0 ? 10 : value;
  }

  Future<void> saveImage({
    required String imagePath,
    double? targetAspectRatio,
  }) async {
    final resolvedImagePath = await _cropCaptureIfNeeded(
      imagePath: imagePath,
      targetAspectRatio: targetAspectRatio,
    );
    logD(
      'Shooting saveImage: path=$resolvedImagePath '
      'exists=${File(resolvedImagePath).existsSync()}',
    );
    uiImages.add(resolvedImagePath);
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
  }

  void acceptLatestCapture() {
    _acceptedCaptureCount = uiImages.length;
    logD('Shooting acceptLatestCapture: accepted=$_acceptedCaptureCount');
    notifyListeners();
  }

  void discardLatestCapture() {
    final imagePath = uiImages.isNotEmpty ? uiImages.removeLast() : null;
    if (tImages.length > uiImages.length) {
      tImages.removeLast();
    }
    if (tVideos.length > uiImages.length) {
      tVideos.removeLast();
    }
    if (_acceptedCaptureCount > uiImages.length) {
      _acceptedCaptureCount = uiImages.length;
    }
    logD('Shooting discardLatestCapture: image=$imagePath');
    notifyListeners();
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
    double? targetAspectRatio,
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
    final resolvedImagePath = await _cropCaptureIfNeeded(
      imagePath: uniquePath,
      targetAspectRatio: targetAspectRatio,
    );
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

    uiImages.add(resolvedImagePath);
    tImages.add(resolvedImagePath);
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

  Future<String> _cropCaptureIfNeeded({
    required String imagePath,
    double? targetAspectRatio,
  }) async {
    final aspectRatio = targetAspectRatio;
    if (aspectRatio == null || aspectRatio <= 0) {
      return imagePath;
    }
    try {
      final croppedPath = await _ffmpegUtils.cropImageToAspectRatio(
        imagePath: imagePath,
        targetAspectRatio: aspectRatio,
      );
      if (croppedPath != imagePath) {
        logD(
          'Shooting crop capture: source=$imagePath '
          'targetAspectRatio=$aspectRatio output=$croppedPath',
        );
      }
      return croppedPath;
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      return imagePath;
    }
  }

  void onNextEvent() async {
    _acceptedCaptureCount = uiImages.length;
    isLoading = true;
    notifyListeners();

    final shouldWaitForVideos = appState.videoExportMode == 'merge';
    if (shouldWaitForVideos) {
      final timeout = DateTime.now().add(const Duration(seconds: 90));
      while (tVideos.length < shotCount && DateTime.now().isBefore(timeout)) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    realDataFiles.clear();
    final orderedImages = [...uiImages];
    final orderedVideos = [...tVideos];
    for (int i = 0; i < orderedImages.length; i++) {
      realDataFiles[orderedImages[i]] =
          i < orderedVideos.length ? orderedVideos[i] : '';
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
