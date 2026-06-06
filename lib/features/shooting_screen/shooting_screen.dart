import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:edsdk/models/camera_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:project_l/common/constants/enum/e_aspect_ratio.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/directory_utils.dart';
import 'package:project_l/common/util/camera_power_util.dart';
import 'package:project_l/common/util/ffmpeg_utils.dart';
import 'package:project_l/common/util/key_map.dart';
import 'package:project_l/common/util/keyboard_windows.dart';
import 'package:project_l/config/injetable_config.dart';
import 'package:project_l/features/shooting_screen/provider/shooting_screen_listen_state.dart';
import 'package:project_l/features/shooting_screen/provider/shooting_screen_provider.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/components/common_counter.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class ShootingScreen extends StatefulWidget {
  const ShootingScreen({super.key});

  @override
  State<ShootingScreen> createState() => _ShootingScreenState();
}

class _ShootingScreenState extends BasePageState<ShootingScreenListenState,
    ShootingScreenProvider, ShootingScreen> {
  CameraController? controller;
  bool get isMockCameraMode => appState.isMockCameraMode;

  int get shotCount {
    final value =
        appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 10;
    return value <= 0 ? 10 : value;
  }

  late final int shootingTime =
      appState.imageParam.selectedFrame.frameSetting?.timePerShot ?? 10;

  late final CommonCounterController _commonCounterController =
      CommonCounterController(defaultTime: shootingTime);

  final CommonCounterController _readyCounterController =
      CommonCounterController(defaultTime: 3)..start();

  bool _isReadyGoVisible = false;
  bool _hasStartedShooting = false;
  bool _hasCanonSession = false;

  @override
  bool isFooterEnabled() {
    return false;
  }

  @override
  bool allowToBack(ShootingScreenProvider provider) {
    return false;
  }

  Timer? t;
  Timer? _canonPreviewTimer;
  _LiveViewShotRecorder? _liveViewShotRecorder;
  String? _mockCapturePath;
  String? _lastCapturedImagePath;
  int? _canonTextureId;
  bool _isCanonRecording = false;
  int _canonShotVideoIndex = 0;

  final ValueNotifier<bool> _shutter = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    GetIt.instance
        .get<FfmpegUtils>()
        .createSession(sessionId: appState.imageParam.session);
    appState.cameraPowerUtil.turnOnCamera();
    if (!isMockCameraMode) {
      t = Timer.periodic(Duration(seconds: 1), (timer) async {
        List<CameraModel> cameraList =
            await appState.cameraUtils.getCameraList();
        logD('Canon camera list: $cameraList');
        if (cameraList.isNotEmpty) {
          timer.cancel();
          final textureId = await appState.cameraUtils.initCamera(0);
          logD('Canon initCamera textureId=$textureId');
          if (textureId >= 0 && mounted) {
            setState(() {
              _canonTextureId = textureId;
            });
          }
          final opened = await appState.cameraUtils.openSession();
          logD('Canon openSession=$opened');
          final savedToHost = await appState.cameraUtils.saveToHost();
          logD('Canon saveToHost=$savedToHost');
          _hasCanonSession = opened;
          if (opened) {
            final previewStarted = await appState.cameraUtils.startPreview();
            logD('Canon startPreview=$previewStarted');
            if (previewStarted) {
              _startCanonPreviewPolling();
            }
          }
        }
      });

      appState.cameraUtils.setObjectHandler(handler: (call) async {
        if (call.method == 'file_created') {
          final imagePath = call.arguments as String;
          logD('Canon file_created: $imagePath');
          if (mounted) {
            setState(() {
              _lastCapturedImagePath = imagePath;
            });
          }
          provider.saveImage(imagePath: imagePath);
          if (provider.uiImages.length < shotCount) {
            _commonCounterController.reset();
            await _startLiveViewRecordingForNextShot();
          } else {
            if (mounted) {
              _commonCounterController.stop();
              provider.onNextEvent();
              Future.delayed(Duration(seconds: 1)).then((_) {
                getIt.get<CameraPowerUtil>().turnOffCamera();
                final keys =
                    "Ctrl+Alt+Shift+Q".split('+').map((k) => k.trim()).toList();

                for (var key in keys) {
                  final keyCode = keyCodeMap[key];
                  if (keyCode != null) {
                    keyDown(keyCode);
                  } else {
                    logU('⚠️ Không tìm thấy phím "$key"');
                  }
                }
                Future.delayed(Duration(milliseconds: 200)).then((_) {
                  for (var key in keys) {
                    final keyCode = keyCodeMap[key];
                    if (keyCode != null) {
                      keyUp(keyCode);
                    } else {
                      logU('⚠️ Không tìm thấy phím "$key"');
                    }
                  }
                });
              });
              // navigator.replaceAll([PhotoSelectionRoute(files: provider.files)]);
            }
          }
        } else if (call.method == 'video_created') {
          final videoPath = call.arguments as String;
          logD('Canon video_created: $videoPath');
          provider.saveVideo(
            videoPath: videoPath,
            second: shootingTime - 1,
          );
        }
      });
    }

    _readyCounterController.addListener(_handleReadyCountdown);
    if (!isMockCameraMode) {
      CameraPlatform.instance.availableCameras().then((value) {
        logD('Available preview cameras: ${value.map((e) => e.name).toList()}');
        setState(() {
          final cameraDescription = _pickPreferredCamera(value);
          controller = CameraController(
              cameraDescription, ResolutionPreset.veryHigh,
              enableAudio: false);
          controller!.initialize().then((_) {
            if (!mounted) {
              return;
            } else {
              setState(() {});
            }
          }).catchError((Object e) {
            if (e is CameraException) {
              switch (e.code) {
                case 'CameraAccessDenied':
                  // Handle access errors here.
                  break;
                default:
                  // Handle other errors here.
                  break;
              }
            }
          });
        });
      });
    }
  }

  Future<String> _ensureMockCapturePath() async {
    if (_mockCapturePath != null && File(_mockCapturePath!).existsSync()) {
      return _mockCapturePath!;
    }
    final folder = await DirectoryUtils.documentDirectory(
      parentFolder: 'mock_capture',
    );
    final sourcePath = 'KHUNG TRƠN TRẮNG/demo_layout.jpg';
    final assetBytes = await _tryLoadMockCaptureAsset(sourcePath);
    final file = File(
      path.join(
        folder,
        'mock_capture_${appState.imageParam.session}_demo_layout.jpg',
      ),
    );
    if (assetBytes != null) {
      await file.writeAsBytes(assetBytes);
    } else {
      final fallbackAsset =
          await rootBundle.load('assets/frame/frame_4_horizontal.png');
      await file.writeAsBytes(fallbackAsset.buffer.asUint8List());
    }
    _mockCapturePath = file.path;
    return file.path;
  }

  Future<Uint8List?> _tryLoadMockCaptureAsset(String assetPath) async {
    final envPath = Platform.environment['PTB_MOCK_CAMERA_IMAGE_PATH']?.trim();
    if (envPath != null && envPath.isNotEmpty) {
      final envFile = File(envPath);
      if (envFile.existsSync()) {
        logD('Using mock camera image from env: $envPath');
        return envFile.readAsBytes();
      }
    }

    try {
      final assetData = await rootBundle.load(assetPath);
      logD('Using mock camera image asset: $assetPath');
      return assetData.buffer.asUint8List();
    } catch (error) {
      logD('Mock camera asset not found: $assetPath');
      return null;
    }
  }

  void _startCanonPreviewPolling() {
    _canonPreviewTimer?.cancel();
    var isDownloading = false;
    _canonPreviewTimer =
        Timer.periodic(const Duration(milliseconds: 66), (timer) async {
      if (!mounted || isDownloading) {
        return;
      }
      isDownloading = true;
      try {
        await appState.cameraUtils.downloadEvfTexture();
      } catch (error, stackTrace) {
        logE(error, stackTrace: stackTrace);
      } finally {
        isDownloading = false;
      }
    });
  }

  CameraDescription _pickPreferredCamera(List<CameraDescription> cameras) {
    final preferred = _firstCameraWhere(cameras, (camera) {
      final name = camera.name.toLowerCase();
      return name.contains('iphone') ||
          name.contains('continuity') ||
          name.contains('facetime') ||
          name.contains('iphone camera');
    });
    if (preferred != null) {
      logD('Using preferred camera: ${preferred.name}');
      return preferred;
    }

    final snapCamera = _firstCameraWhere(
      cameras,
      (camera) => camera.name.toLowerCase().contains('snap'),
    );
    if (snapCamera != null) {
      logD('Using snap camera: ${snapCamera.name}');
      return snapCamera;
    }

    logD('Using first camera: ${cameras.first.name}');
    return cameras.first;
  }

  CameraDescription? _firstCameraWhere(
    List<CameraDescription> cameras,
    bool Function(CameraDescription camera) test,
  ) {
    for (final camera in cameras) {
      if (test(camera)) {
        return camera;
      }
    }
    return null;
  }

  @override
  bool isShowCountDown() {
    return false;
  }

  @override
  void dispose() {
    if (!isMockCameraMode) {
      _canonPreviewTimer?.cancel();
      _liveViewShotRecorder?.cancel();
      appState.cameraUtils.stopPreview();
      appState.cameraUtils.closeSession();
    }
    controller?.dispose();
    appState.cameraPowerUtil.turnOffCamera();
    _commonCounterController.dispose();
    _readyCounterController.dispose();
    t?.cancel();
    super.dispose();
  }

  void _handleReadyCountdown() {
    if (_readyCounterController.currentCounter != 0 ||
        _isReadyGoVisible ||
        _hasStartedShooting) {
      return;
    }
    setState(() {
      _isReadyGoVisible = true;
    });
    Future.delayed(const Duration(milliseconds: 850), () {
      if (!mounted || _hasStartedShooting) {
        return;
      }
      _beginShootingCycle();
    });
  }

  void _beginShootingCycle() {
    _hasStartedShooting = true;
    _isReadyGoVisible = false;
    _commonCounterController.start();
    _commonCounterController.addListener(_handleShotCountdown);
    if (!isMockCameraMode && _hasCanonSession) {
      unawaited(_startLiveViewRecordingForNextShot());
    }
    setState(() {});
  }

  Future<void> _startLiveViewRecordingForNextShot() async {
    if (isMockCameraMode || !_hasCanonSession) {
      return;
    }
    _canonShotVideoIndex++;
    final ffmpegUtils = GetIt.instance.get<FfmpegUtils>();
    final recorder = _LiveViewShotRecorder(
      cameraUtils: appState.cameraUtils,
      ffmpegUtils: ffmpegUtils,
      sessionId: appState.imageParam.session,
      shotIndex: _canonShotVideoIndex,
      logD: logD,
      logE: (error, stackTrace) => logE(error, stackTrace: stackTrace),
    );
    _liveViewShotRecorder = recorder;
    await recorder.start();
  }

  void _stopLiveViewRecordingForCurrentShot() {
    final recorder = _liveViewShotRecorder;
    if (recorder == null) {
      return;
    }
    _liveViewShotRecorder = null;
    unawaited(recorder.stopAndEncode().then((videoFile) {
      if (videoFile == null) {
        logE('LiveView video encode failed');
        return;
      }
      provider.saveVideo(
        videoPath: videoFile.path,
        second: shootingTime - 1,
      );
    }));
  }

  Future<void> _startCanonRecordIfNeeded() async {
    if (isMockCameraMode || !_hasCanonSession || _isCanonRecording) {
      return;
    }
    final started = await appState.cameraUtils.startRecord();
    logD('Canon startRecord=$started');
    _isCanonRecording = started;
  }

  Future<void> _stopCanonRecordIfNeeded() async {
    if (!_isCanonRecording) {
      return;
    }
    final stopped = await appState.cameraUtils.stopRecord();
    logD('Canon stopRecord=$stopped');
    _isCanonRecording = !stopped;
  }

  Future<void> _handleShotCountdown() async {
    if (_commonCounterController.currentCounter == 0) {
      if (isMockCameraMode) {
        final imagePath = await _ensureMockCapturePath();
        await provider.saveMockCapture(imagePath: imagePath);
        if (mounted) {
          setState(() {
            _lastCapturedImagePath =
                provider.latestPreviewImagePath ?? imagePath;
          });
        }
        _shutter.value = true;
        if (provider.uiImages.length < shotCount) {
          _commonCounterController.reset();
        } else {
          if (mounted) {
            _commonCounterController.stop();
            provider.onNextEvent();
          }
        }
      } else {
        final videoFile = await _stopVideoRecordingIfNeeded();
        _shutter.value = true;
        if (appState.isMockPaymentMode && !_hasCanonSession) {
          final imageFile = await _takeLaptopCameraPicture();
          if (imageFile == null) return;
          await provider.saveMockCapture(
            imagePath: imageFile.path,
            videoPath: videoFile?.path,
          );
          if (mounted) {
            setState(() {
              _lastCapturedImagePath =
                  provider.latestPreviewImagePath ?? imageFile.path;
            });
          }
          if (provider.uiImages.length < shotCount) {
            _commonCounterController.reset();
          } else {
            if (mounted) {
              _commonCounterController.stop();
              provider.onNextEvent();
            }
          }
          return;
        }
        if (videoFile != null) {
          provider.saveVideo(
            videoPath: videoFile.path,
            second: shootingTime - 1,
          );
        }
        _stopLiveViewRecordingForCurrentShot();
        final shootResult = await appState.cameraUtils.shoot();
        logD('Canon shoot result=$shootResult');
      }
    } else {
      if (!isMockCameraMode && !(controller?.value.isRecordingVideo ?? false)) {
        await _startVideoRecordingIfNeeded();
      }
    }
  }

  Future<XFile?> _stopVideoRecordingIfNeeded() async {
    if (!(controller?.value.isRecordingVideo ?? false)) {
      return null;
    }
    try {
      return controller?.stopVideoRecording();
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> _startVideoRecordingIfNeeded() async {
    if (controller == null ||
        !controller!.value.isInitialized ||
        controller!.value.isRecordingVideo) {
      return;
    }
    try {
      await controller!.startVideoRecording();
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
    }
  }

  Future<XFile?> _takeLaptopCameraPicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      return null;
    }
    try {
      return controller!.takePicture();
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  void listenState(ShootingScreenListenState event) {
    if (event is ShootingScreenSuccessState) {
      AutoRouter.of(context)
          .replace(PhotoSelectionRoute(files: provider.realDataFiles));
    }
    super.listenState(event);
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    var isVertical = appState.isMockCameraMode
        ? false
        : appState.imageParam.selectedFrame.isVertical();
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListenableBuilder(
        builder: (context, _) {
          if (!_hasStartedShooting) {
            return _ShootingCanvas(
              count: provider.uiImages.length,
              total: shotCount,
              showShotCounter: false,
              child: _ReadyCountdownOverlay(
                count: _readyCounterController.currentCounter,
                showReadyGo: _isReadyGoVisible,
              ),
            );
          }

          return ListenableBuilder(
            listenable: Listenable.merge([
              _commonCounterController,
              provider,
            ]),
            builder: (context, _) {
              final capturedPreviewPath =
                  _lastCapturedImagePath ?? provider.latestPreviewImagePath;
              return _ShootingCanvas(
                count: provider.uiImages.length,
                total: shotCount,
                showShotCounter: false,
                child: provider.isLoading
                    ? Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText(
                              textAlign: TextAlign.center,
                              flashyBoothText(
                                context,
                                vi: 'Đang xử lý ảnh và video, vui lòng chờ...',
                                en: 'Processing photos and videos, please wait...',
                              ),
                              speed: Duration(milliseconds: 300),
                              textStyle: style8072600.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                          isRepeatingAnimation: true,
                        ),
                      )
                    : _CameraCaptureLayout(
                        secondsLeft: _commonCounterController.currentCounter,
                        shotCount: provider.uiImages.length,
                        totalShots: shotCount,
                        preview: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: isMockCameraMode
                                  ? const _CameraPreviewPlaceholder()
                                  : _canonTextureId != null
                                      ? _CanonCapturePreview(
                                          imagePath: capturedPreviewPath,
                                          textureId: _canonTextureId,
                                        )
                                      : controller != null
                                          ? Transform.flip(
                                              flipY: true,
                                              flipX: false,
                                              child: CameraPreview(controller!),
                                            )
                                          : _CanonCapturePreview(
                                              imagePath: capturedPreviewPath,
                                              textureId: _canonTextureId,
                                            ),
                            ),
                            if (!isMockCameraMode && controller != null)
                              Positioned.fill(
                                child: EAspectRatio.sixteenNine.coverWidget(
                                  isVertical: isVertical,
                                ),
                              ),
                            _CapturedImageOverlay(
                              imagePath: _canonTextureId == null
                                  ? capturedPreviewPath
                                  : null,
                            ),
                            Positioned.fill(
                              child: ListenableBuilder(
                                builder: (context, _) {
                                  return ShutterEffect(
                                    trigger: _shutter.value,
                                    onShutterEnd: () => _shutter.value = false,
                                  );
                                },
                                listenable: _shutter,
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            },
          );
        },
        listenable: Listenable.merge([
          _readyCounterController,
          provider,
        ]),
      ),
    );
  }
}

class _ShootingCanvas extends StatelessWidget {
  const _ShootingCanvas({
    required this.count,
    required this.total,
    required this.child,
    this.showShotCounter = true,
  });

  final int count;
  final int total;
  final Widget child;
  final bool showShotCounter;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            top: 24.h,
            left: 28.w,
            child: const FlashyBoothLanguagePill(),
          ),
          if (showShotCounter)
            Positioned(
              top: 38.h,
              right: 56.w,
              child: _ShotCounterPill(count: count, total: total),
            ),
        ],
      ),
    );
  }
}

class _CameraCaptureLayout extends StatelessWidget {
  const _CameraCaptureLayout({
    required this.secondsLeft,
    required this.shotCount,
    required this.totalShots,
    required this.preview,
  });

  final int secondsLeft;
  final int shotCount;
  final int totalShots;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxPreviewWidth = constraints.maxWidth;
        final maxPreviewHeight = constraints.maxHeight;
        var previewWidth = maxPreviewWidth;
        var previewHeight = previewWidth / 16 * 9;
        if (previewHeight > maxPreviewHeight) {
          previewHeight = maxPreviewHeight;
          previewWidth = previewHeight / 9 * 16;
        }
        return Stack(
          children: [
            Center(
              child: _CameraPreviewFrame(
                width: previewWidth,
                height: previewHeight,
                child: preview,
              ),
            ),
            Positioned(
              top: 24.h,
              right: 28.w,
              child: _CameraStatusHud(
                secondsLeft: secondsLeft,
                shotCount: shotCount,
                totalShots: totalShots,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CameraStatusHud extends StatelessWidget {
  const _CameraStatusHud({
    required this.secondsLeft,
    required this.shotCount,
    required this.totalShots,
  });

  final int secondsLeft;
  final int shotCount;
  final int totalShots;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.34),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ShotTimerCircle(secondsLeft: secondsLeft),
              14.horizontalSpace,
              _ShotCounterPill(count: shotCount, total: totalShots),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShotTimerCircle extends StatelessWidget {
  const _ShotTimerCircle({required this.secondsLeft});

  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.w,
      height: 68.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4.w,
        ),
      ),
      child: Text(
        secondsLeft.toString(),
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}

class _CameraPreviewFrame extends StatelessWidget {
  const _CameraPreviewFrame({
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF122040),
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF154273).withValues(alpha: 0.2),
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _CameraCornerPainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraPreviewPlaceholder extends StatelessWidget {
  const _CameraPreviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF202844),
            Color(0xFF0A4B82),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.white.withValues(alpha: 0.16),
              size: 38.r,
            ),
            18.verticalSpace,
            Text(
              'CAMERA PREVIEW',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 6.w,
                color: Colors.white.withValues(alpha: 0.24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveViewShotRecorder {
  _LiveViewShotRecorder({
    required this.cameraUtils,
    required this.ffmpegUtils,
    required this.sessionId,
    required this.shotIndex,
    required this.logD,
    required this.logE,
  });

  static const int _fps = 10;

  final dynamic cameraUtils;
  final FfmpegUtils ffmpegUtils;
  final String sessionId;
  final int shotIndex;
  final void Function(String message) logD;
  final void Function(Object error, StackTrace? stackTrace) logE;

  Timer? _timer;
  Directory? _frameDir;
  int _frameIndex = 0;
  bool _isCapturing = false;
  bool _isStopped = false;

  Future<void> start() async {
    final parent = await DirectoryUtils.documentDirectory(
      parentFolder: 'live_view_frames',
    );
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final directory = Directory(
      path.join(parent, '${sessionId}_shot_${shotIndex}_$timestamp'),
    );
    await directory.create(recursive: true);
    _frameDir = directory;
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => unawaited(_captureFrame()),
    );
    await _captureFrame();
    logD('LiveView recording start: shot=$shotIndex dir=${directory.path}');
  }

  Future<void> _captureFrame() async {
    if (_isStopped || _isCapturing) {
      return;
    }
    final directory = _frameDir;
    if (directory == null) {
      return;
    }
    _isCapturing = true;
    try {
      final bytes = await cameraUtils.downloadEvfBytes();
      if (bytes.isEmpty) {
        return;
      }
      _frameIndex++;
      final framePath = path.join(
        directory.path,
        'frame_${_frameIndex.toString().padLeft(6, '0')}.jpg',
      );
      await File(framePath).writeAsBytes(bytes, flush: false);
    } catch (error, stackTrace) {
      logE(error, stackTrace);
    } finally {
      _isCapturing = false;
    }
  }

  Future<File?> stopAndEncode() async {
    _isStopped = true;
    _timer?.cancel();
    while (_isCapturing) {
      await Future.delayed(const Duration(milliseconds: 20));
    }
    final directory = _frameDir;
    if (directory == null || _frameIndex == 0) {
      logD('LiveView recording skipped: shot=$shotIndex frames=$_frameIndex');
      return null;
    }
    final framePattern = path.join(directory.path, 'frame_%06d.jpg');
    logD('LiveView recording encode: shot=$shotIndex frames=$_frameIndex');
    final encoded = await ffmpegUtils.encodeLiveViewFrames(
      framePattern: framePattern,
      fps: _fps,
    );
    logD('LiveView recording done: shot=$shotIndex video=${encoded?.path}');
    return encoded;
  }

  void cancel() {
    _isStopped = true;
    _timer?.cancel();
  }
}

class _CapturedImageOverlay extends StatelessWidget with LogMixin {
  const _CapturedImageOverlay({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final value = imagePath;
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }

    final file = File(value);
    if (!file.existsSync()) {
      return const SizedBox.shrink();
    }

    try {
      final bytes = file.readAsBytesSync();
      final modified = file.lastModifiedSync().microsecondsSinceEpoch;
      return Positioned.fill(
        child: Image.memory(
          bytes,
          key: ValueKey('captured:${file.path}:$modified'),
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            logE(error, stackTrace: stackTrace);
            return const SizedBox.shrink();
          },
        ),
      );
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      return const SizedBox.shrink();
    }
  }
}

class _CanonCapturePreview extends StatelessWidget {
  const _CanonCapturePreview({
    required this.imagePath,
    required this.textureId,
  });

  final String? imagePath;
  final int? textureId;

  @override
  Widget build(BuildContext context) {
    final valueTextureId = textureId;
    if (valueTextureId != null && valueTextureId >= 0) {
      return Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black),
          Texture(
            textureId: valueTextureId,
            filterQuality: FilterQuality.medium,
          ),
        ],
      );
    }

    final value = imagePath;
    if (value == null || value.isEmpty || !File(value).existsSync()) {
      return const _CameraPreviewPlaceholder();
    }
    final file = File(value);
    return Image.memory(
      file.readAsBytesSync(),
      key: ValueKey(
          '${file.path}:${file.lastModifiedSync().microsecondsSinceEpoch}'),
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }
}

class _CameraCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final inset = 13.w;
    final length = 30.w;

    void corner(Offset origin, double xSign, double ySign) {
      canvas.drawLine(origin, origin + Offset(length * xSign, 0), paint);
      canvas.drawLine(origin, origin + Offset(0, length * ySign), paint);
    }

    corner(Offset(inset, inset), 1, 1);
    corner(Offset(size.width - inset, inset), -1, 1);
    corner(Offset(inset, size.height - inset), 1, -1);
    corner(Offset(size.width - inset, size.height - inset), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShotCounterPill extends StatelessWidget {
  const _ShotCounterPill({required this.count, required this.total});

  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138.w,
      height: 64.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2C31),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '$count / $total',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style4060400.copyWith(
          color: Colors.white,
          fontSize: 34.sp,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _ReadyCountdownOverlay extends StatelessWidget {
  const _ReadyCountdownOverlay({
    required this.count,
    required this.showReadyGo,
  });

  final int count;
  final bool showReadyGo;

  @override
  Widget build(BuildContext context) {
    final safeCount = count.clamp(1, 3);
    return ColoredBox(
      color: const Color(0xFF05050D),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: showReadyGo
              ? const _ReadyGoMark(key: ValueKey('ready_go'))
              : _CountdownMark(
                  key: ValueKey('count_$safeCount'),
                  count: safeCount,
                ),
        ),
      ),
    );
  }
}

class _CountdownMark extends StatelessWidget {
  const _CountdownMark({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 480.w,
      height: 230.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'S37',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 108.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.08),
              height: 0.9,
            ),
          ),
          Text(
            '$count',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 118.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 0.9,
            ),
          ),
          Positioned(
            bottom: 34.h,
            child: Text(
              'GET READY...',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 7.w,
                color: Colors.white.withValues(alpha: 0.55),
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadyGoMark extends StatelessWidget {
  const _ReadyGoMark({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 650.w,
      height: 250.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'READY GO',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 92.sp,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.1),
              height: 1,
            ),
          ),
          Text(
            'READY GO',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 70.sp,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ShutterEffect extends StatefulWidget {
  final bool trigger;
  final VoidCallback onShutterEnd;

  const ShutterEffect({
    super.key,
    required this.trigger,
    required this.onShutterEnd,
  });

  @override
  State<ShutterEffect> createState() => _ShutterEffectState();
}

class _ShutterEffectState extends State<ShutterEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topHeight;
  late Animation<double> _bottomHeight;
  late Animation<double> _blurSigma; // <--- thêm

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _topHeight = Tween<double>(begin: 0, end: 0.5).animate(animation);
    _bottomHeight = Tween<double>(begin: 0, end: 0.5).animate(animation);
    _blurSigma =
        Tween<double>(begin: 0.0, end: 10.0).animate(animation); // <-- thêm

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse(); // Mở màn chập ra lại
      }
      if (status == AnimationStatus.dismissed) {
        widget.onShutterEnd();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ShutterEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final h = constraints.maxHeight;
              return Stack(
                children: [
                  // Layer motion blur
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _blurSigma.value,
                        sigmaY: _blurSigma.value,
                      ),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  // Layer shutter (2 màn đen)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: _topHeight.value * h,
                    child: Container(color: Colors.black),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: _bottomHeight.value * h,
                    child: Container(color: Colors.black),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
