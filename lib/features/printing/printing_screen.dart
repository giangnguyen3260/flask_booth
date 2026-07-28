import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/windows_util.dart';
import 'package:project_l/features/printing/provider/printing_screen_listen_state.dart';
import 'package:project_l/features/printing/provider/printing_screen_provider.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

@RoutePage()
class PrintingScreen extends StatefulWidget {
  const PrintingScreen({super.key, required this.transformationControllers});

  final List<TransformationController> transformationControllers;

  @override
  State<PrintingScreen> createState() => _PrintingScreenState();
}

class _PrintingScreenState extends BasePageState<PrintingScreenListenState,
    PrintingScreenProvider, PrintingScreen> {
  Size _backgroundSize = const Size(1, 1);
  String _lastLoadedBackgroundPath = "";

  String get _resolvedFrameOverlaySourcePath =>
      appState.imageParam.selectedFrame.frameUrlTempDis ??
      appState.imageParam.selectedFrame.frameUrl ??
      "";

  String get _resolvedSceneBackground {
    final selectedBackground = appState.imageParam.selectedBackground;
    final backgroundPath = selectedBackground.bgUrl ?? "";
    if (backgroundPath.isNotEmpty && File(backgroundPath).existsSync()) {
      return backgroundPath;
    }
    if (_resolvedFrameOverlaySourcePath.isNotEmpty &&
        File(_resolvedFrameOverlaySourcePath).existsSync()) {
      return _resolvedFrameOverlaySourcePath;
    }
    return "";
  }

  Future<void> _loadBackgroundSize(String backgroundPath) async {
    if (backgroundPath.isEmpty || backgroundPath == _lastLoadedBackgroundPath) {
      return;
    }
    final backgroundFile = File(backgroundPath);
    if (!backgroundFile.existsSync()) {
      return;
    }
    try {
      final bytes = await backgroundFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final width = frame.image.width.toDouble();
      final height = frame.image.height.toDouble();
      frame.image.dispose();
      codec.dispose();
      if (!mounted || width <= 1 || height <= 1) {
        return;
      }
      setState(() {
        _backgroundSize = Size(width, height);
        _lastLoadedBackgroundPath = backgroundPath;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadBackgroundSize(_resolvedSceneBackground));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final exported = await provider.exportFiles();
      if (!mounted) {
        return;
      }
      if (!exported) {
        await Future<void>.delayed(const Duration(seconds: 3));
        if (mounted) {
          navigator.replaceAll([StandByRoute()]);
        }
        return;
      }
    });
  }

  @override
  bool allowToBack(PrintingScreenProvider provider) {
    return false;
  }

  @override
  bool isShowCountDown() {
    return false;
  }

  @override
  int countDuration() {
    return getCounterAtIndex(8);
  }

  @override
  void onTimeEnd() {
    navigator.replaceAll([StandByRoute()]);
  }

  @override
  void dispose() async {
    super.dispose();
    if (await WindowsUtil.getAppMemoryUsage() >=
        (appState.appConfig['max_ram'] ?? 2048)) {
      WindowsUtil.restartApp(
          appName: appState.appConfig['app_name'] ?? "project_l");
    }
  }

  @override
  Widget buildPage(BuildContext context, double maxWidth, double maxHeight) {
    final sceneBackground = _resolvedSceneBackground;
    if (sceneBackground.isNotEmpty &&
        sceneBackground != _lastLoadedBackgroundPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_loadBackgroundSize(sceneBackground));
        }
      });
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding =
            max(64.w, min(118.w, constraints.maxWidth * 0.065));
        final topPadding = max(58.h, min(88.h, constraints.maxHeight * 0.085));
        final contentGap = max(54.w, constraints.maxWidth * 0.055);
        return Stack(
          children: [
            const FlashyBoothReferenceBackground(),
            const FlashyBoothStepBar(currentIndex: 8),
            Positioned(
              top: 36.h,
              right: 72.w,
              child: const FlashyBoothLanguagePill(),
            ),
            Positioned(
              top: 36.h,
              right: 204.w,
              child: _buildCloseAppButton(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                48.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlashyBoothScreenTitle(
                    title: flashyBoothText(
                      context,
                      vi: 'Ảnh đã sẵn sàng',
                      en: 'Your photos are ready',
                    ),
                    subtitle: flashyBoothSecondaryText(
                      context,
                      vi: 'Ảnh đã sẵn sàng',
                      en: 'Download photos and videos',
                    ),
                    titleSize: 58.sp,
                    subtitleSize: 26.sp,
                    subtitleItalic: true,
                  ),
                  34.verticalSpace,
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: min(500.w, constraints.maxWidth * 0.32),
                          child: _buildDownloadPanelCard(),
                        ),
                        SizedBox(width: contentGap),
                        Expanded(
                          child: Center(child: _buildPrintPreviewCard()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDownloadPanelCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(28.w, 30.h, 28.w, 28.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.12),
          width: 1.4.w,
        ),
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(alpha: 0.08),
            blurRadius: 28.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: _buildDownloadPanel(),
    );
  }

  Widget _buildDownloadPanel() {
    return Selector<PrintingScreenProvider, Uint8List>(
      selector: (_, provider) => provider.qrCode,
      builder: (context, qr, child) {
        final isUploadQueued = context.select<PrintingScreenProvider, bool>(
          (provider) => provider.isUploadQueued,
        );
        final status = context.select<PrintingScreenProvider, String>(
          (provider) => provider.preparationStatus,
        );
        final isReady = qr.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildDownloadPreviewBox()),
            24.verticalSpace,
            Container(
              width: double.infinity,
              height: 8.h,
              decoration: BoxDecoration(
                color: isReady
                    ? const Color(0xFF208A4A)
                    : isUploadQueued
                        ? const Color(0xFFB88416)
                        : FlashyBoothColors.pink.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            12.verticalSpace,
            Text(
              isReady
                  ? flashyBoothText(
                      context,
                      vi: 'Quét QR để tải ảnh',
                      en: 'Scan QR to download',
                    )
                  : isUploadQueued
                      ? flashyBoothText(
                          context,
                          vi: 'Dang cho upload khi co mang',
                          en: 'Waiting to upload when online',
                        )
                      : flashyBoothText(
                          context,
                          vi: status.isEmpty
                              ? 'Đang chuẩn bị ảnh của bạn...'
                              : status,
                          en: status.isEmpty
                              ? 'Preparing your photos...'
                              : status,
                        ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: FlashyBoothColors.pink,
                height: 1.1,
              ),
            ),
            26.verticalSpace,
            Text(
              flashyBoothText(
                context,
                vi: 'Tải ảnh về điện thoại',
                en: 'Download to your phone',
              ),
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 34.sp,
                fontWeight: FontWeight.w900,
                color: FlashyBoothColors.pink,
                height: 1,
              ),
            ),
            10.verticalSpace,
            Text(
              flashyBoothSecondaryText(
                context,
                vi: 'Tải ảnh và video về điện thoại',
                en: 'Download photos and videos to phone',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: FlashyBoothColors.pink.withValues(alpha: 0.48),
                height: 1.2,
              ),
            ),
            const Spacer(),
            _buildFinishButton(),
          ],
        );
      },
    );
  }

  Widget _buildQrBox() {
    return Selector<PrintingScreenProvider, (Uint8List, bool)>(
      selector: (_, provider) => (provider.qrCode, provider.isUploadQueued),
      builder: (context, state, child) {
        final qr = state.$1;
        final isUploadQueued = state.$2;
        return Container(
          width: 246.w,
          height: 246.w,
          padding: EdgeInsets.all(qr.isEmpty ? 54.r : 14.r),
          decoration: BoxDecoration(
            color: FlashyBoothColors.pink,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: FlashyBoothColors.pink.withValues(alpha: 0.28),
                blurRadius: 28.r,
                offset: Offset(0, 14.h),
              ),
            ],
          ),
          child: qr.isEmpty
              ? Center(
                  child: isUploadQueued
                      ? Icon(
                          Icons.cloud_off_rounded,
                          color: Colors.white,
                          size: 62.r,
                        )
                      : SizedBox(
                          width: 58.r,
                          height: 58.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 6,
                            color: Colors.white,
                          ),
                        ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Image.memory(qr, fit: BoxFit.cover),
                ),
        );
      },
    );
  }

  Widget _buildDownloadPreviewBox() {
    return Selector<PrintingScreenProvider, (Uint8List, bool, String, String)>(
      selector: (_, provider) => (
        provider.qrCode,
        provider.isUploadQueued,
        provider.finalPreviewImagePath,
        provider.preparationStatus,
      ),
      builder: (context, state, child) {
        final qr = state.$1;
        final isUploadQueued = state.$2;
        final finalImagePath = state.$3;
        final status = state.$4;
        final hasFinalImage =
            finalImagePath.isNotEmpty && File(finalImagePath).existsSync();
        if (qr.isNotEmpty) {
          return _buildQrBox();
        }
        return Container(
          width: 246.w,
          height: 246.w,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: FlashyBoothColors.pink,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: FlashyBoothColors.pink.withValues(alpha: 0.28),
                blurRadius: 28.r,
                offset: Offset(0, 14.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: Colors.white,
                  child: hasFinalImage
                      ? Image.file(
                          File(finalImagePath),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        )
                      : _buildProcessingPreview(
                          status: status,
                          compact: true,
                        ),
                ),
                Positioned(
                  right: 10.r,
                  bottom: 10.r,
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.54),
                      shape: BoxShape.circle,
                    ),
                    child: isUploadQueued
                        ? Icon(
                            Icons.cloud_off_rounded,
                            color: Colors.white,
                            size: 22.r,
                          )
                        : Padding(
                            padding: EdgeInsets.all(9.r),
                            child: const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrintPreviewCard() {
    final aspectRatio = _backgroundSize.width / _backgroundSize.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxCardWidth = min(430.w, constraints.maxWidth * 0.88);
        final maxCardHeight = min(690.h, constraints.maxHeight * 0.92);
        var cardWidth = maxCardWidth;
        var cardHeight = cardWidth / aspectRatio;
        if (cardHeight > maxCardHeight) {
          cardHeight = maxCardHeight;
          cardWidth = cardHeight * aspectRatio;
        }
        return Container(
          width: cardWidth + 28.w,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: FlashyBoothColors.pink.withValues(alpha: 0.14),
                blurRadius: 36.r,
                offset: Offset(0, 16.h),
              ),
            ],
          ),
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: _buildFinalPreview(),
          ),
        );
      },
    );
  }

  Widget _buildFinalPreview() {
    return Selector<PrintingScreenProvider, (String, String)>(
      selector: (_, provider) => (
        provider.finalPreviewImagePath,
        provider.preparationStatus,
      ),
      builder: (context, state, child) {
        final finalImagePath = state.$1;
        final status = state.$2;
        if (finalImagePath.isNotEmpty && File(finalImagePath).existsSync()) {
          return Image.file(
            File(finalImagePath),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          );
        }
        return _buildProcessingPreview(status: status);
      },
    );
  }

  Widget _buildProcessingPreview({
    required String status,
    bool compact = false,
  }) {
    final label = status.isEmpty ? 'Preparing your photos...' : status;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6FB),
        borderRadius: BorderRadius.circular(compact ? 6.r : 10.r),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(compact ? 20.r : 36.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: compact ? 42.r : 76.r,
                height: compact ? 42.r : 76.r,
                child: CircularProgressIndicator(
                  strokeWidth: compact ? 5.r : 7.r,
                  color: FlashyBoothColors.pink,
                  backgroundColor:
                      FlashyBoothColors.pink.withValues(alpha: 0.12),
                ),
              ),
              if (!compact) ...[
                28.verticalSpace,
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: FlashyBoothColors.pink,
                    height: 1.15,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Please wait',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: FlashyBoothColors.pink.withValues(alpha: 0.48),
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Material(
      color: FlashyBoothColors.pink,
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: () {
          navigator.replaceAll([StandByRoute()]);
        },
        child: SizedBox(
          width: 230.w,
          height: 72.h,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  flashyBoothText(context, vi: 'Kết thúc', en: 'Finish'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                12.horizontalSpace,
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 28.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseAppButton() {
    return Tooltip(
      message: 'Close app',
      child: SizedBox(
        width: 58.w,
        height: 58.w,
        child: Material(
          color: Colors.white.withValues(alpha: 0.65),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: windowManager.close,
            child: Center(
              child: Icon(
                Icons.power_settings_new_rounded,
                color: FlashyBoothColors.pink,
                size: 27.r,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WavyCircleClipper extends CustomClipper<Path> {
  final double waveAmplitude;
  final int waveCount;

  WavyCircleClipper({
    this.waveAmplitude = 6.0,
    this.waveCount = 80,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - waveAmplitude;

    for (int i = 0; i <= waveCount; i++) {
      final angle = (2 * pi / waveCount) * i;
      final wave = sin(i * 2 * pi / 10) * waveAmplitude;

      final r = radius + wave;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
