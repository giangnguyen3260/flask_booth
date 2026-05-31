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

  @override
  bool isFooterEnabled() {
    return false;
  }

  @override
  bool allowToBack(ShootingScreenProvider provider) {
    return false;
  }

  Timer? t;
  String? _mockCapturePath;

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
        if (cameraList.isNotEmpty) {
          timer.cancel();
          await appState.cameraUtils.initCamera(0);
          await appState.cameraUtils.openSession();
          await appState.cameraUtils.saveToHost();
        }
      });

      appState.cameraUtils.setObjectHandler(handler: (call) async {
        if (call.method == 'file_created') {
          provider.saveImage(imagePath: call.arguments as String);
          if (provider.uiImages.length < shotCount) {
            _commonCounterController.reset();
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
    setState(() {});
  }

  Future<void> _handleShotCountdown() async {
    if (_commonCounterController.currentCounter == 0) {
      if (isMockCameraMode) {
        final imagePath = await _ensureMockCapturePath();
        await provider.saveMockCapture(imagePath: imagePath);
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
        var videoFile = await controller?.stopVideoRecording();
        if (videoFile == null) return;
        provider.saveVideo(videoPath: videoFile.path, second: shootingTime - 1);
        _shutter.value = true;
        appState.cameraUtils.shoot();
      }
    } else {
      if (!isMockCameraMode && !(controller?.value.isRecordingVideo ?? false)) {
        await controller?.startVideoRecording();
      }
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
            listenable: _commonCounterController,
            builder: (context, _) {
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
                                  : controller != null
                                      ? Transform.flip(
                                          flipY: true,
                                          flipX: false,
                                          child: CameraPreview(controller!),
                                        )
                                      : const _CameraPreviewPlaceholder(),
                            ),
                            if (!isMockCameraMode && controller != null)
                              Positioned.fill(
                                child: EAspectRatio.sixteenNine.coverWidget(
                                  isVertical: isVertical,
                                ),
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
        listenable: _readyCounterController,
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF29304D).withValues(alpha: 0.42),
                      const Color(0xFF0C4D82).withValues(alpha: 0.28),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
