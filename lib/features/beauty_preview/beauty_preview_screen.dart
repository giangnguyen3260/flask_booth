import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/features/beauty_preview/provider/beauty_preview_listen_state.dart';
import 'package:project_l/features/beauty_preview/provider/beauty_preview_provider.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/components/live_beauty_filter.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class BeautyPreviewScreen extends StatefulWidget {
  const BeautyPreviewScreen({super.key});

  @override
  State<BeautyPreviewScreen> createState() => _BeautyPreviewScreenState();
}

class _BeautyPreviewScreenState extends BasePageState<BeautyPreviewListenState,
    BeautyPreviewProvider, BeautyPreviewScreen> {
  CameraController? _controller;
  bool _isCameraLoading = true;

  @override
  void afterFirstBuild() {
    provider.init();
    appState.cameraPowerUtil.turnOnCamera();
    _initCameraPreview();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  bool isShowCountDown() {
    return false;
  }

  @override
  bool allowToBack(BeautyPreviewProvider provider) {
    return false;
  }

  @override
  bool isFooterEnabled() {
    return false;
  }

  @override
  void onNext(BeautyPreviewProvider provider) {
    super.onNext(provider);
    provider.saveSelection();
    navigator.replaceAll([StandByRoute(), ShootingGuideRouteRoute()]);
  }

  Future<void> _initCameraPreview() async {
    try {
      final cameras = await CameraPlatform.instance.availableCameras();
      if (!mounted || cameras.isEmpty) {
        setState(() {
          _isCameraLoading = false;
        });
        return;
      }

      final camera = _pickPreferredCamera(cameras);
      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _isCameraLoading = false;
      });
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _isCameraLoading = false;
        });
      }
    }
  }

  CameraDescription _pickPreferredCamera(List<CameraDescription> cameras) {
    for (final camera in cameras) {
      if (camera.name.toLowerCase().contains('snap')) {
        return camera;
      }
    }
    return cameras.first;
  }

  @override
  Widget buildPage(BuildContext context, double maxWidth, double maxHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 1180;
        final previewWidth =
            (constraints.maxWidth * (isCompact ? 0.78 : 0.52)).clamp(
          560.0,
          980.0,
        );
        final previewHeight = previewWidth * 0.64;

        return Stack(
          children: [
            const FlashyBoothReferenceBackground(),
            const FlashyBoothStepBar(currentIndex: 4),
            Positioned(
              top: 30.h,
              right: 112.w,
              child: const FlashyBoothLanguagePill(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 56.w, vertical: 86.h),
              child: ListenableBuilder(
                listenable: provider,
                builder: (context, _) {
                  final preview = _BeautyCameraPreview(
                    controller: _controller,
                    isLoading: _isCameraLoading,
                    beautyEnabled: provider.beautyEnabled,
                  );

                  final tools = _BeautyPreviewTools(
                    beautyEnabled: provider.beautyEnabled,
                    onNatural: () => provider.setBeautyEnabled(false),
                    onBeauty: () => provider.setBeautyEnabled(true),
                    onContinue: () => onNext(provider),
                  );

                  return isCompact
                      ? Column(
                          children: [
                            SizedBox(
                              width: previewWidth,
                              height: previewHeight,
                              child: preview,
                            ),
                            34.verticalSpace,
                            Expanded(child: tools),
                          ],
                        )
                      : Row(
                          children: [
                            SizedBox(
                              width: previewWidth,
                              height: previewHeight,
                              child: preview,
                            ),
                            62.horizontalSpace,
                            Expanded(child: tools),
                          ],
                        );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BeautyCameraPreview extends StatelessWidget {
  const _BeautyCameraPreview({
    required this.controller,
    required this.isLoading,
    required this.beautyEnabled,
  });

  final CameraController? controller;
  final bool isLoading;
  final bool beautyEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B2C),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.18),
          width: 2.w,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: controller != null && controller!.value.isInitialized
            ? LiveBeautyFilter(
                enabled: beautyEnabled,
                child: _BeautyCameraFeed(controller: controller!),
              )
            : _BeautyPreviewPlaceholder(isLoading: isLoading),
      ),
    );
  }
}

class _BeautyCameraFeed extends StatelessWidget {
  const _BeautyCameraFeed({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final aspectRatio = controller.value.aspectRatio;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: aspectRatio * 1000,
          height: 1000,
          child: Transform.flip(
            flipX: true,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}

class _BeautyPreviewPlaceholder extends StatelessWidget {
  const _BeautyPreviewPlaceholder({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.camera_alt,
            size: 54.r,
            color: FlashyBoothColors.pink.withValues(alpha: 0.42),
          ),
          20.verticalSpace,
          Text(
            isLoading ? 'CAMERA PREVIEW' : 'NO CAMERA',
            maxLines: 1,
            style: style24400.copyWith(
              color: FlashyBoothColors.pinkLight,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BeautyPreviewTools extends StatelessWidget {
  const _BeautyPreviewTools({
    required this.beautyEnabled,
    required this.onNatural,
    required this.onBeauty,
    required this.onContinue,
  });

  final bool beautyEnabled;
  final VoidCallback onNatural;
  final VoidCallback onBeauty;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlashyBoothScreenTitle(
          title: flashyBoothText(
            context,
            vi: 'Kiểm tra camera',
            en: 'Camera Preview',
          ),
          subtitle: flashyBoothSecondaryText(
            context,
            vi: 'Chọn màu da trước khi chụp',
            en: 'Choose your look before shooting',
          ),
        ),
        34.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _BeautyModeButton(
                title: flashyBoothText(context, vi: 'Tự nhiên', en: 'Natural'),
                selected: !beautyEnabled,
                onTap: onNatural,
              ),
            ),
            18.horizontalSpace,
            Expanded(
              child: _BeautyModeButton(
                title: flashyBoothText(
                  context,
                  vi: 'Sáng mịn da',
                  en: 'Smooth Rose',
                ),
                selected: beautyEnabled,
                onTap: onBeauty,
              ),
            ),
          ],
        ),
        42.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: FlashyBoothPillButton(
            label: flashyBoothText(context, vi: 'Tiếp tục', en: 'Continue'),
            subLabel: flashyBoothSecondaryText(
              context,
              vi: 'Tiếp tục',
              en: 'Continue',
            ),
            onTap: onContinue,
            width: 296.w,
            height: 82.h,
            labelSize: 30.sp,
            subLabelSize: 15.sp,
          ),
        ),
      ],
    );
  }
}

class _BeautyModeButton extends StatelessWidget {
  const _BeautyModeButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        fixedSize: Size.fromHeight(58.h),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        side: BorderSide(
          color: selected ? FlashyBoothColors.pink : Colors.black26,
          width: 2.w,
        ),
        backgroundColor: selected
            ? FlashyBoothColors.pink.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.54),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            size: 28.r,
            color: selected ? FlashyBoothColors.pink : Colors.black45,
          ),
          12.horizontalSpace,
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style24400.copyWith(
                color: selected ? FlashyBoothColors.pink : Colors.black87,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
