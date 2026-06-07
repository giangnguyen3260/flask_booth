import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/extensions/widget_extensions.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/frame_overlay_mask_utils.dart';
import 'package:project_l/common/util/windows_util.dart';
import 'package:project_l/features/printing/provider/printing_screen_listen_state.dart';
import 'package:project_l/features/printing/provider/printing_screen_provider.dart';
import 'package:project_l/gen/assets.gen.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
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
  //todo replace real transparent areas
  late final List<List<double>> _transparentAreas =
      appState.imageParam.selectedFrame.getDisplayTransparentAreas(
    fallbackCount:
        appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 0,
  );

  //todo replace real background size
  late final Size _backgroundSize = Size(
      appState.imageParam.selectedFrame.getSize().$1,
      appState.imageParam.selectedFrame.getSize().$2);

  final FrameOverlayMaskUtils _frameOverlayMaskUtils = FrameOverlayMaskUtils();
  String _frameOverlaySourcePath = "";
  String _maskedFrameOverlayPath = "";

  bool get _isVertical => appState.imageParam.selectedFrame.isVertical();

  String get _resolvedFrameOverlaySourcePath =>
      _frameOverlaySourcePath.isNotEmpty
          ? _frameOverlaySourcePath
          : appState.imageParam.selectedFrame.frameUrlTempDis ??
              appState.imageParam.selectedFrame.frameUrl ??
              "";

  String get _resolvedFrameOverlayDisplayPath =>
      _maskedFrameOverlayPath.isNotEmpty
          ? _maskedFrameOverlayPath
          : _resolvedFrameOverlaySourcePath;

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

  String get _resolvedFrameOverlay {
    final frameOverlay = _resolvedFrameOverlayDisplayPath;
    if (frameOverlay.isNotEmpty && File(frameOverlay).existsSync()) {
      return frameOverlay;
    }
    return "";
  }

  Future<void> _prepareMaskedFrameOverlay() async {
    final masked = await _frameOverlayMaskUtils
        .resolveMaskedOverlayPath(_resolvedFrameOverlaySourcePath);
    if (!mounted) {
      return;
    }
    setState(() {
      _maskedFrameOverlayPath = masked;
    });
  }

  final List<VideoPlayerController> _videoPlayerControllers = [];

  @override
  void initState() {
    super.initState();
    _frameOverlaySourcePath =
        appState.imageParam.selectedFrame.frameUrlTempDis ??
            appState.imageParam.selectedFrame.frameUrl ??
            "";
    _maskedFrameOverlayPath = _frameOverlaySourcePath;
    unawaited(_prepareMaskedFrameOverlay());
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
      if (appState.imageParam.videos.isEmpty) {
        return;
      }
      if (appState.imageParam.videos.length > 1) {
        return;
      }

      // Initialize first video
      var firstController =
          VideoPlayerController.file(File(appState.imageParam.videos[0]));
      await firstController.initialize();
      await firstController.setLooping(true);
      await firstController.play();
      _videoPlayerControllers.add(firstController);

      // Initialize second video, then the rest, sequentially
      for (int i = 1; i < appState.imageParam.videos.length; i++) {
        var controller =
            VideoPlayerController.file(File(appState.imageParam.videos[i]));
        await controller.initialize();
        await controller.setLooping(true);
        await controller.play();
        _videoPlayerControllers.add(controller);
      }

      setState(() {}); // Update the UI after initializing all controllers
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
    for (var video in _videoPlayerControllers) {
      await video.dispose();
    }
    if (await WindowsUtil.getAppMemoryUsage() >=
        (appState.appConfig['max_ram'] ?? 2048)) {
      WindowsUtil.restartApp(
          appName: appState.appConfig['app_name'] ?? "project_l");
    }
  }

  @override
  Widget buildPage(BuildContext context, double maxWidth, double maxHeight) {
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
    return Selector<PrintingScreenProvider, (Uint8List, bool, String)>(
      selector: (_, provider) => (
        provider.qrCode,
        provider.isUploadQueued,
        provider.finalPrintImagePath,
      ),
      builder: (context, state, child) {
        final qr = state.$1;
        final isUploadQueued = state.$2;
        final finalImagePath = state.$3;
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
                      : _buildLivePreview(),
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
    return Stack(
      children: [
        Selector<PrintingScreenProvider, String>(
          selector: (_, provider) => provider.finalPrintImagePath,
          builder: (context, finalImagePath, child) {
            if (finalImagePath.isNotEmpty &&
                File(finalImagePath).existsSync()) {
              return Positioned.fill(
                child: Image.file(
                  File(finalImagePath),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              );
            }
            return child ?? const SizedBox.shrink();
          },
          child: Positioned.fill(child: _buildLivePreview()),
        ),
      ],
    );
  }

  Widget _buildLivePreview() {
    return LayoutBuilder(
      builder: (context, constraint) {
        final render = _resolveRenderMetrics(
          Size(constraint.maxWidth, constraint.maxHeight),
        );
        final holeRects = List<Rect>.generate(
          _transparentAreas.length,
          (i) => Rect.fromLTWH(
            render.offsetX + _transparentAreas[i][0] * render.scaleWidth,
            render.offsetY + _transparentAreas[i][1] * render.scaleHeight,
            _transparentAreas[i][2] * render.scaleWidth,
            _transparentAreas[i][3] * render.scaleHeight,
          ),
        );
        return Stack(
          children: [
            Positioned.fill(
              child: ClipPath(
                clipper: _TransparentHolesClipper(holeRects: holeRects),
                child: _resolvedSceneBackground.isEmpty
                    ? Container(color: Colors.white)
                    : Image.file(
                        File(_resolvedSceneBackground),
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
              ),
            ),
            ...List.generate(
              min(_videoPlayerControllers.length, _transparentAreas.length),
              (i) => _buildVideoSlot(i, render),
            ),
            Positioned.fill(
              child: _resolvedFrameOverlay.isEmpty
                  ? Image.asset(
                      _isVertical
                          ? Assets.frame.frame4Vertical.path
                          : Assets.frame.frame4Horizontal.path,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    )
                  : Image.file(
                      File(_resolvedFrameOverlay),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoSlot(int index, _RenderMetrics render) {
    final controller = _videoPlayerControllers[index];
    final slotWidth = _transparentAreas[index][2] * render.scaleWidth;
    final slotHeight = _transparentAreas[index][3] * render.scaleHeight;
    return Positioned(
      left: render.offsetX + _transparentAreas[index][0] * render.scaleWidth,
      top: render.offsetY + _transparentAreas[index][1] * render.scaleHeight,
      width: slotWidth,
      height: slotHeight,
      child: ClipRect(
        child: InteractiveViewer(
          transformationController: widget.transformationControllers[index],
          scaleEnabled: false,
          panEnabled: false,
          minScale: 1,
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: SizedBox(
              height: 1,
              width: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ).flip(isFlip: appState.imageParam.isFlipped),
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

  _RenderMetrics _resolveRenderMetrics(Size containerSize) {
    final fitted = applyBoxFit(
      BoxFit.contain,
      _backgroundSize,
      containerSize,
    );
    final renderWidth = fitted.destination.width;
    final renderHeight = fitted.destination.height;
    return _RenderMetrics(
      offsetX: (containerSize.width - renderWidth) / 2,
      offsetY: (containerSize.height - renderHeight) / 2,
      scaleWidth: renderWidth / _backgroundSize.width,
      scaleHeight: renderHeight / _backgroundSize.height,
    );
  }
}

class _RenderMetrics {
  const _RenderMetrics({
    required this.offsetX,
    required this.offsetY,
    required this.scaleWidth,
    required this.scaleHeight,
  });

  final double offsetX;
  final double offsetY;
  final double scaleWidth;
  final double scaleHeight;
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

class _TransparentHolesClipper extends CustomClipper<Path> {
  const _TransparentHolesClipper({required this.holeRects});

  final List<Rect> holeRects;

  @override
  Path getClip(Size size) {
    final path = Path()..fillType = PathFillType.evenOdd;
    path.addRect(Offset.zero & size);
    for (final rect in holeRects) {
      path.addRect(rect);
    }
    return path;
  }

  @override
  bool shouldReclip(covariant _TransparentHolesClipper oldClipper) {
    if (oldClipper.holeRects.length != holeRects.length) {
      return true;
    }
    for (var i = 0; i < holeRects.length; i++) {
      if (oldClipper.holeRects[i] != holeRects[i]) {
        return true;
      }
    }
    return false;
  }
}
