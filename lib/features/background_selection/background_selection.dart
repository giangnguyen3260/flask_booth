import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/enums/filter_enum.dart';
import 'package:project_l/common/extensions/widget_extensions.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/frame_overlay_mask_utils.dart';
import 'package:project_l/features/background_selection/provider/background_selection_listen_state.dart';
import 'package:project_l/features/background_selection/provider/background_selection_provider.dart';
import 'package:project_l/gen/assets.gen.dart';
import 'package:project_l/remote/models/app_data.dart';
import 'package:project_l/resources/components/common_shader_image.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class BackgroundSelectionScreen extends StatefulWidget {
  const BackgroundSelectionScreen({super.key});

  @override
  State<BackgroundSelectionScreen> createState() =>
      _BackgroundSelectionScreenState();
}

class _BackgroundSelectionScreenState extends BasePageState<
    BackgroundSelectionListenState,
    BackgroundSelectionProvider,
    BackgroundSelectionScreen> with LogMixin {
  late final List<List<double>> _transparentAreas =
      appState.imageParam.selectedFrame.getDisplayTransparentAreas(
    fallbackCount:
        appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 0,
  );

  late final Size _backgroundSize = Size(
    appState.imageParam.selectedFrame.getSize().$1,
    appState.imageParam.selectedFrame.getSize().$2,
  );

  final FrameOverlayMaskUtils _frameOverlayMaskUtils = FrameOverlayMaskUtils();
  String _frameOverlaySourcePath = '';
  String _maskedFrameOverlayPath = '';
  Size _innerTransparentSize = Size.zero;
  bool _didLogFirstFrame = false;
  FilterEnum? _activeAdjustment;

  late final List<TransformationController> _transformControllers =
      List.generate(
    appState.imageParam.images.length,
    (_) => TransformationController(),
  );

  List<BackgroundInfo> get _backgroundInfo =>
      _resolvedBackgroundInfo(appState.imageParam.selectedFrame);

  List<BackgroundInfo> get _displayBackgroundInfo => _backgroundInfo.isNotEmpty
      ? _backgroundInfo
      : [
          BackgroundInfo(
            bgCateNm: 'Mặc định',
            bgCateIcon: appState.imageParam.selectedFrame.frameUrlTempDis ??
                appState.imageParam.selectedFrame.frameUrl,
            background: [
              Background(
                bgUrl: appState.imageParam.selectedFrame.frameUrlTempDis ??
                    appState.imageParam.selectedFrame.frameUrl,
              ),
            ],
          ),
        ];

  int get _safeCategoryIndex {
    if (_displayBackgroundInfo.isEmpty) {
      return 0;
    }
    return provider.currentCategoryIndex.clamp(
      0,
      _displayBackgroundInfo.length - 1,
    );
  }

  List<Background> get _selectedBackgroundList {
    if (_displayBackgroundInfo.isEmpty) {
      return [];
    }
    return _displayBackgroundInfo[_safeCategoryIndex].background ?? [];
  }

  Background? get _selectedBackground {
    if (provider.currentBackgroundIndex < 0) {
      return null;
    }
    final backgrounds = _selectedBackgroundList;
    if (backgrounds.isEmpty ||
        provider.currentBackgroundIndex >= backgrounds.length) {
      return null;
    }
    return backgrounds[provider.currentBackgroundIndex];
  }

  bool get _isVertical => appState.imageParam.selectedFrame.isVertical();

  String get _resolvedFrameOverlaySourcePath =>
      _frameOverlaySourcePath.isNotEmpty
          ? _frameOverlaySourcePath
          : appState.imageParam.selectedFrame.frameUrlTempDis ??
              appState.imageParam.selectedFrame.frameUrl ??
              '';

  String get _resolvedFrameOverlayDisplayPath =>
      _maskedFrameOverlayPath.isNotEmpty
          ? _maskedFrameOverlayPath
          : _resolvedFrameOverlaySourcePath;

  String _resolveBackgroundPath(String candidate) {
    if (candidate.isNotEmpty && File(candidate).existsSync()) {
      return candidate;
    }
    return _isVertical
        ? Assets.frame.frame4Vertical.path
        : Assets.frame.frame4Horizontal.path;
  }

  @override
  bool isShowNext(BackgroundSelectionProvider provider) {
    return false;
  }

  @override
  bool isShowCountDown() {
    return false;
  }

  @override
  bool isFooterEnabled() {
    return false;
  }

  @override
  bool allowToBack(BackgroundSelectionProvider provider) {
    return false;
  }

  @override
  void afterFirstBuild() {
    final stopwatch = Stopwatch()..start();
    _frameOverlaySourcePath =
        appState.imageParam.selectedFrame.frameUrlTempDis ??
            appState.imageParam.selectedFrame.frameUrl ??
            '';
    _maskedFrameOverlayPath = _frameOverlaySourcePath;
    provider.initPreset();
    logD(
      'PERF BackgroundSelection.afterFirstBuild init frame=${appState.imageParam.selectedFrame.frameCd} images=${appState.imageParam.images.length} transparent=${_transparentAreas.length} backgroundCategories=${_backgroundInfo.length} elapsed=${stopwatch.elapsedMilliseconds}ms',
    );
    if (_displayBackgroundInfo.isNotEmpty) {
      provider.changeCurrentCategoryIndex(0);
      final backgrounds = _displayBackgroundInfo.first.background ?? [];
      if (backgrounds.isNotEmpty) {
        provider.changeCurrentBackgroundIndex(0);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      logD(
        'PERF BackgroundSelection.mask start elapsed=${stopwatch.elapsedMilliseconds}ms source=$_frameOverlaySourcePath',
      );
      unawaited(_prepareMaskedFrameOverlay());
    });
    super.afterFirstBuild();
  }

  @override
  int countDuration() {
    return 500;
  }

  @override
  void onTimeEnd() {
    _submitBackgroundSelection();
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    final buildStopwatch = Stopwatch()..start();
    final frameOverlayPath = _resolveBackgroundPath(
      _resolvedFrameOverlayDisplayPath,
    );
    final sceneBackgroundPath = _resolveBackgroundPath(
      (_selectedBackground?.bgUrl ?? '').isNotEmpty
          ? (_selectedBackground?.bgUrl ?? '')
          : _resolvedFrameOverlaySourcePath,
    );
    if (!_didLogFirstFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _didLogFirstFrame = true;
        logD(
          'PERF BackgroundSelection.firstFrame elapsed=${buildStopwatch.elapsedMilliseconds}ms frameOverlayExists=${File(frameOverlayPath).existsSync()} backgroundExists=${File(sceneBackgroundPath).existsSync()}',
        );
      });
    }

    return Stack(
      children: [
        const FlashyBoothReferenceBackground(),
        const FlashyBoothStepBar(currentIndex: 7),
        Positioned(
          top: 36.h,
          right: 72.w,
          child: const FlashyBoothLanguagePill(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(54.w, 76.h, 54.w, 34.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: math.min(300.w, maxWidth * 0.19),
                child: _SideToolPanel(child: _buildEditTools()),
              ),
              34.horizontalSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: _buildFramePreview(
                          frameOverlayPath: frameOverlayPath,
                          sceneBackgroundPath: sceneBackgroundPath,
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    _buildPrintButton(),
                  ],
                ),
              ),
              42.horizontalSpace,
              SizedBox(
                width: math.min(430.w, maxWidth * 0.26),
                child: _SideToolPanel(child: _buildBackgroundTools()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _prepareMaskedFrameOverlay() async {
    final stopwatch = Stopwatch()..start();
    final masked = await _frameOverlayMaskUtils
        .resolveMaskedOverlayPath(_frameOverlaySourcePath);
    if (!mounted) {
      return;
    }
    setState(() {
      _maskedFrameOverlayPath = masked;
    });
    logD(
      'PERF BackgroundSelection.mask end elapsed=${stopwatch.elapsedMilliseconds}ms masked=$masked',
    );
  }

  Widget _buildEditTools() {
    final blackWhiteValue =
        ((1 - provider.effect.saturation).clamp(0.0, 1.0) * 100).toDouble();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlashyBoothScreenTitle(
            title: flashyBoothText(context, vi: 'Chỉnh ảnh', en: 'Edit Photo'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'Chỉnh ảnh',
              en: 'Edit Photo',
            ),
          ),
          28.verticalSpace,
          _EditToolButton(
            title: flashyBoothText(context, vi: 'Gốc', en: 'Original'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'Gốc',
              en: 'Original',
            ),
            selected: provider.currentFilterIndex < 0 &&
                !appState.imageParam.isFlipped &&
                _activeAdjustment == null,
            onTap: () {
              provider.redo(false);
              appState.updateFlip(false);
              setState(() {
                _activeAdjustment = null;
              });
            },
          ),
          18.verticalSpace,
          _EditToolButton(
            title: flashyBoothText(context, vi: 'Độ sáng', en: 'Brightness'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'Độ sáng',
              en: 'Brightness',
            ),
            selected: _activeAdjustment == FilterEnum.brightness,
            onTap: () {
              setState(() {
                _activeAdjustment = FilterEnum.brightness;
              });
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _activeAdjustment == FilterEnum.brightness
                ? Padding(
                    key: const ValueKey('brightness-slider'),
                    padding: EdgeInsets.only(top: 12.h),
                    child: _AdjustmentSlider(
                      label: flashyBoothText(
                        context,
                        vi: 'Cường độ sáng',
                        en: 'Brightness level',
                      ),
                      valueLabel: FilterEnum.brightness
                          .getLabel(provider.effect.brightness),
                      value: provider.effect.brightness,
                      min: FilterEnum.brightness.getRange().$1,
                      max: FilterEnum.brightness.getRange().$2,
                      divisions: 60,
                      onChanged: (value) {
                        provider.changeEffect(value, FilterEnum.brightness);
                      },
                      onReset: () {
                        provider.changeEffect(
                          FilterEnum.brightness.getDefaultValue(),
                          FilterEnum.brightness,
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          18.verticalSpace,
          _EditToolButton(
            title: flashyBoothText(context, vi: 'Đen trắng', en: 'B/W'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'Đen trắng',
              en: 'B/W',
            ),
            selected: _activeAdjustment == FilterEnum.saturation,
            onTap: () {
              setState(() {
                _activeAdjustment = FilterEnum.saturation;
              });
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _activeAdjustment == FilterEnum.saturation
                ? Padding(
                    key: const ValueKey('black-white-slider'),
                    padding: EdgeInsets.only(top: 12.h),
                    child: _AdjustmentSlider(
                      label: flashyBoothText(
                        context,
                        vi: 'Mức đen trắng',
                        en: 'B/W level',
                      ),
                      valueLabel: '${blackWhiteValue.round()}%',
                      value: blackWhiteValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        provider.changeEffect(
                          1 - (value / 100),
                          FilterEnum.saturation,
                        );
                      },
                      onReset: () {
                        provider.changeEffect(
                          FilterEnum.saturation.getDefaultValue(),
                          FilterEnum.saturation,
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          18.verticalSpace,
          _EditToolButton(
            title: flashyBoothText(context, vi: 'Lật ngang', en: 'Flip H'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'Lật ngang',
              en: 'Flip H',
            ),
            selected: appState.imageParam.isFlipped,
            onTap: () {
              appState.updateFlip(!appState.imageParam.isFlipped);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFramePreview({
    required String frameOverlayPath,
    required String sceneBackgroundPath,
  }) {
    final aspectRatio = _backgroundSize.width / _backgroundSize.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxPreviewWidth = math.min(610.w, constraints.maxWidth * 0.92);
        final maxPreviewHeight = math.min(760.h, constraints.maxHeight * 0.92);
        var previewWidth = maxPreviewWidth;
        var previewHeight = previewWidth / aspectRatio;
        if (previewHeight > maxPreviewHeight) {
          previewHeight = maxPreviewHeight;
          previewWidth = previewHeight * aspectRatio;
        }
        return Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: FlashyBoothColors.pink.withValues(alpha: 0.13),
                blurRadius: 34.r,
                offset: Offset(0, 16.h),
              ),
            ],
          ),
          child: SizedBox(
            width: previewWidth,
            height: previewHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: _buildBackgroundLayer(sceneBackgroundPath),
                ),
                Positioned.fill(
                  child: _buildPhotoLayer(),
                ),
                Positioned.fill(
                  child: Image.file(
                    File(frameOverlayPath),
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundLayer(String sceneBackgroundPath) {
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
        return ClipPath(
          clipper: _TransparentHolesClipper(holeRects: holeRects),
          child: Image.file(
            File(sceneBackgroundPath),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        );
      },
    );
  }

  Widget _buildPhotoLayer() {
    return LayoutBuilder(
      builder: (context, constraint) {
        final render = _resolveRenderMetrics(
          Size(constraint.maxWidth, constraint.maxHeight),
        );
        final slotCount = math.min(
          _transparentAreas.length,
          appState.imageParam.images.length,
        );
        return Stack(
          children: List.generate(slotCount, (i) {
            final imagePath = appState.imageParam.images[i];
            final width = _transparentAreas[i][2] * render.scaleWidth;
            final height = _transparentAreas[i][3] * render.scaleHeight;
            _innerTransparentSize = Size(width, height);

            return Positioned(
              left:
                  render.offsetX + _transparentAreas[i][0] * render.scaleWidth,
              top:
                  render.offsetY + _transparentAreas[i][1] * render.scaleHeight,
              width: width,
              height: height,
              child: imagePath.isEmpty
                  ? const SizedBox.shrink()
                  : ClipRect(
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 1.8,
                        transformationController: _transformControllers[i],
                        trackpadScrollCausesScale: true,
                        child: CommonShaderImage(
                          effect: provider.effect,
                          imagePath: imagePath,
                        ).flip(isFlip: appState.imageParam.isFlipped),
                      ),
                    ),
            );
          }),
        );
      },
    );
  }

  Widget _buildBackgroundTools() {
    final backgrounds = _selectedBackgroundList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FlashyBoothScreenTitle(
                title: flashyBoothText(
                  context,
                  vi: 'Chọn nền',
                  en: 'Select Background',
                ),
                subtitle: flashyBoothSecondaryText(
                  context,
                  vi: 'Chọn nền',
                  en: 'Select Background',
                ),
                align: TextAlign.right,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),
        26.verticalSpace,
        SizedBox(
          height: 46.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = _displayBackgroundInfo[index];
              return _CategoryChip(
                label: _backgroundCategoryLabel(context, category.bgCateNm),
                selected: index == _safeCategoryIndex,
                onTap: () {
                  provider.changeCurrentCategoryIndex(index);
                  final categoryBackgrounds =
                      _displayBackgroundInfo[index].background ?? [];
                  if (categoryBackgrounds.isNotEmpty) {
                    provider.changeCurrentBackgroundIndex(0);
                  }
                },
              );
            },
            separatorBuilder: (_, __) => 12.horizontalSpace,
            itemCount: _displayBackgroundInfo.length,
          ),
        ),
        18.verticalSpace,
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: FlashyBoothColors.pink.withValues(alpha: 0.16),
                width: 1.5.w,
              ),
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: backgrounds.length <= 2 ? 1 : 2,
                mainAxisSpacing: 18.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                return _BackgroundTile(
                  background: backgrounds[index],
                  selected: index == provider.currentBackgroundIndex,
                  onTap: () => provider.changeCurrentBackgroundIndex(index),
                );
              },
              itemCount: backgrounds.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrintButton() {
    return SizedBox(
      width: 230.w,
      height: 66.h,
      child: ElevatedButton(
        onPressed: _submitBackgroundSelection,
        style: ElevatedButton.styleFrom(
          backgroundColor: FlashyBoothColors.pink,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              flashyBoothText(context, vi: 'In ảnh', en: 'Print'),
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            10.horizontalSpace,
            Icon(Icons.arrow_forward, size: 28.r),
          ],
        ),
      ),
    );
  }

  void _submitBackgroundSelection() {
    try {
      final selectedBackground = _selectedBackground ?? _fallbackBackground();
      if (selectedBackground == null) {
        throw StateError('Background not selected');
      }
      appState.updateBackground(selectedBackground);
    } catch (e) {
      logE(e);
      toastification.show(
        type: ToastificationType.error,
        primaryColor: Colors.black,
        style: ToastificationStyle.minimal,
        context: context,
        title:
            Text(flashyBoothTextRead(context, vi: 'Thông báo', en: 'Notice')),
        description: Text(
          flashyBoothTextRead(
            context,
            vi: 'Hãy chọn nền trước khi tiếp tục',
            en: 'Please select a background before continuing',
          ),
        ),
        borderSide: const BorderSide(color: Colors.black38),
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }
    next();
  }

  String _backgroundCategoryLabel(BuildContext context, String? label) {
    final normalized = (label ?? '').trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'mặc định') {
      return flashyBoothText(context, vi: 'Mặc định', en: 'Default');
    }
    return normalized;
  }

  Background? _fallbackBackground() {
    if (_displayBackgroundInfo.isEmpty) {
      return null;
    }
    final category = _displayBackgroundInfo[_safeCategoryIndex];
    final backgrounds = category.background ?? [];
    if (backgrounds.isEmpty) {
      return null;
    }
    final selectedIndex = provider.currentBackgroundIndex;
    if (selectedIndex >= 0 && selectedIndex < backgrounds.length) {
      return backgrounds[selectedIndex];
    }
    return backgrounds.first;
  }

  List<BackgroundInfo> _resolvedBackgroundInfo(FramesInfo frame) {
    final directInfo = frame.backgroundInfo ?? [];
    if (directInfo.isNotEmpty) {
      return directInfo;
    }
    final frameCd = frame.frameCd;
    if (frameCd == null || frameCd.trim().isEmpty) {
      return _fallbackBackgroundInfoByLayout(frame);
    }
    final matchedFrame = appState.frameInfos.firstWhere(
      (item) =>
          (item.frameCd ?? '').trim().toLowerCase() ==
          frameCd.trim().toLowerCase(),
      orElse: () => frame,
    );
    final matchedInfo = matchedFrame.backgroundInfo ?? [];
    if (matchedInfo.isNotEmpty) {
      return matchedInfo;
    }
    return _fallbackBackgroundInfoByLayout(frame);
  }

  List<BackgroundInfo> _fallbackBackgroundInfoByLayout(FramesInfo frame) {
    final targetNumOfPhotos = frame.frameSetting?.numOfPhotos ?? 0;
    final targetVertical = frame.isVertical();
    final matchedFrame = appState.frameInfos.firstWhere(
      (item) =>
          (item.frameSetting?.numOfPhotos ?? 0) == targetNumOfPhotos &&
          item.isVertical() == targetVertical &&
          (item.backgroundInfo ?? []).isNotEmpty,
      orElse: () => frame,
    );
    return matchedFrame.backgroundInfo ?? [];
  }

  void next() {
    appState.updateEffect(provider.effect);
    final innerTransparentSize =
        appState.imageParam.selectedFrame.getInnerImageSize();
    provider.updateMatrix(
      List.generate(
        _transformControllers.length,
        (index) => _transformControllers[index].value.row0.r,
      ),
      List.generate(
        _transformControllers.length,
        (index) => _transformControllers[index].value.row0.a,
      ),
      List.generate(
        _transformControllers.length,
        (index) => _transformControllers[index].value.row1.a,
      ),
      innerTransparentSize.$1 / math.max(_innerTransparentSize.width, 1),
      innerTransparentSize.$2 / math.max(_innerTransparentSize.height, 1),
    );

    context.router.replace(
      PrintingRoute(transformationControllers: _transformControllers),
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

class _EditToolButton extends StatelessWidget {
  const _EditToolButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.selected = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FlashyBoothColors.pink : Colors.white,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
          decoration: BoxDecoration(
            border: Border.all(color: FlashyBoothColors.pink, width: 2.w),
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w900,
                  color: selected ? Colors.white : FlashyBoothColors.pink,
                  height: 1.05,
                ),
              ),
              5.verticalSpace,
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white.withValues(alpha: 0.78)
                      : FlashyBoothColors.pink.withValues(alpha: 0.72),
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdjustmentSlider extends StatelessWidget {
  const _AdjustmentSlider({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.onReset,
  });

  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.24),
          width: 1.4.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: FlashyBoothColors.pink,
                    height: 1,
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                valueLabel,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: FlashyBoothColors.pink,
                  height: 1,
                ),
              ),
              8.horizontalSpace,
              SizedBox(
                width: 30.r,
                height: 30.r,
                child: IconButton(
                  onPressed: onReset,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 18.r,
                    color: FlashyBoothColors.pink,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: FlashyBoothColors.pink,
              inactiveTrackColor:
                  FlashyBoothColors.pink.withValues(alpha: 0.18),
              thumbColor: Colors.white,
              overlayColor: FlashyBoothColors.pink.withValues(alpha: 0.12),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 9.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 17.r),
              trackHeight: 5.h,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _SideToolPanel extends StatelessWidget {
  const _SideToolPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 22.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.64),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.12),
          width: 1.3.w,
        ),
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(alpha: 0.08),
            blurRadius: 28.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FlashyBoothColors.pink : Colors.white,
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          constraints: BoxConstraints(minWidth: 112.w),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            border: Border.all(color: FlashyBoothColors.pink, width: 1.5.w),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : FlashyBoothColors.pink,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundTile extends StatelessWidget {
  const _BackgroundTile({
    required this.background,
    required this.selected,
    required this.onTap,
  });

  final Background background;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final path = background.bgUrl ?? '';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: selected
                        ? FlashyBoothColors.pink
                        : FlashyBoothColors.pink.withValues(alpha: 0.24),
                    width: selected ? 4.w : 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: FlashyBoothColors.pink.withValues(alpha: 0.1),
                      blurRadius: 18.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: path.isNotEmpty && File(path).existsSync()
                    ? Image.file(
                        File(path),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            if (selected)
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: FlashyBoothColors.pink,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.w),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 26.r,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
