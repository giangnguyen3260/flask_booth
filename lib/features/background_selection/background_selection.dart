import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

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
  Size _backgroundSize = const Size(1, 1);
  String _lastLoadedBgPath = '';

  List<List<double>> get _effectiveTransparentAreas {
    final bgAreas = _selectedBackground?.getTransparentAreas() ?? [];
    if (bgAreas.isNotEmpty) return bgAreas;
    return appState.imageParam.selectedFrame.getDisplayTransparentAreas(
      fallbackCount:
          appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 0,
    );
  }

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
            bgCateNm: 'M\u1eb7c \u0111\u1ecbnh',
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
      'PERF BackgroundSelection.afterFirstBuild init frame=${appState.imageParam.selectedFrame.frameCd} images=${appState.imageParam.images.length} transparent=${_effectiveTransparentAreas.length} backgroundCategories=${_backgroundInfo.length} elapsed=${stopwatch.elapsedMilliseconds}ms',
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
      unawaited(_loadBackgroundSize(_selectedBackground?.bgUrl ?? ''));
    });
    super.afterFirstBuild();
  }

  Future<void> _loadBackgroundSize(String bgPath) async {
    if (bgPath.isEmpty || bgPath == _lastLoadedBgPath) return;
    if (!File(bgPath).existsSync()) return;
    try {
      final bytes = await File(bgPath).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width.toDouble();
      final h = frame.image.height.toDouble();
      frame.image.dispose();
      if (mounted && w > 1 && h > 1) {
        setState(() {
          _backgroundSize = Size(w, h);
          _lastLoadedBgPath = bgPath;
        });
      }
    } catch (_) {}
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
    final sceneBackgroundPath = _resolveBackgroundPath(
      (_selectedBackground?.bgUrl ?? '').isNotEmpty
          ? (_selectedBackground?.bgUrl ?? '')
          : _resolvedFrameOverlaySourcePath,
    );
    if (sceneBackgroundPath != _lastLoadedBgPath &&
        sceneBackgroundPath.isNotEmpty &&
        !sceneBackgroundPath.startsWith('assets/')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_loadBackgroundSize(sceneBackgroundPath));
      });
    }
    if (!_didLogFirstFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _didLogFirstFrame = true;
        logD(
          'PERF BackgroundSelection.firstFrame elapsed=${buildStopwatch.elapsedMilliseconds}ms backgroundExists=${File(sceneBackgroundPath).existsSync()}',
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
            title: flashyBoothText(context, vi: 'Ch\u1ec9nh \u1ea3nh', en: 'Edit Photo'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'Ch\u1ec9nh \u1ea3nh',
              en: 'Edit Photo',
            ),
          ),
          28.verticalSpace,
          _EditToolButton(
            title: flashyBoothText(context, vi: 'G\u1ed1c', en: 'Original'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'G\u1ed1c',
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
          _buildAdjustmentTool(
            title: flashyBoothText(
              context,
              vi: 'T\u01b0\u01a1ng ph\u1ea3n',
              en: 'Contrast',
            ),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'T\u01b0\u01a1ng ph\u1ea3n',
              en: 'Contrast',
            ),
            label: flashyBoothText(
              context,
              vi: 'M\u1ee9c t\u01b0\u01a1ng ph\u1ea3n',
              en: 'Contrast level',
            ),
            activeType: FilterEnum.contrast,
            value: FilterEnum.contrast.toUIValue(provider.effect.contrast),
            min: -100,
            max: 100,
            divisions: 200,
            onChanged: (value) {
              provider.changeEffect(
                FilterEnum.contrast.fromUIValue(value),
                FilterEnum.contrast,
              );
            },
            onReset: () {
              provider.changeEffect(
                FilterEnum.contrast.getDefaultValue(),
                FilterEnum.contrast,
              );
            },
          ),
          18.verticalSpace,
          _buildAdjustmentTool(
            title: flashyBoothText(
              context,
              vi: 'M\u00e0u s\u1eafc',
              en: 'Color',
            ),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'M\u00e0u s\u1eafc',
              en: 'Saturation',
            ),
            label: flashyBoothText(
              context,
              vi: '\u0110\u1ed9 \u0111\u1eadm m\u00e0u',
              en: 'Color level',
            ),
            activeType: FilterEnum.vibrance,
            value: FilterEnum.saturation.toUIValue(provider.effect.saturation),
            min: -100,
            max: 100,
            divisions: 200,
            onChanged: (value) {
              provider.changeEffect(
                FilterEnum.saturation.fromUIValue(value),
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
          18.verticalSpace,
          _buildAdjustmentTool(
            title: flashyBoothText(
              context,
              vi: '\u1ea4m/l\u1ea1nh',
              en: 'Warm/Cool',
            ),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: '\u1ea4m/l\u1ea1nh',
              en: 'Temperature',
            ),
            label: flashyBoothText(
              context,
              vi: 'Nhi\u1ec7t \u0111\u1ed9 m\u00e0u',
              en: 'Warm / cool',
            ),
            activeType: FilterEnum.temperature,
            value:
                FilterEnum.temperature.toUIValue(provider.effect.temperature),
            min: -100,
            max: 100,
            divisions: 200,
            onChanged: (value) {
              provider.changeEffect(
                FilterEnum.temperature.fromUIValue(value),
                FilterEnum.temperature,
              );
            },
            onReset: () {
              provider.changeEffect(
                FilterEnum.temperature.getDefaultValue(),
                FilterEnum.temperature,
              );
            },
          ),
          24.verticalSpace,
          _buildPresetFilters(),
          18.verticalSpace,
          _EditToolButton(
            title: flashyBoothText(context, vi: '\u0110\u1ed9 s\u00e1ng', en: 'Brightness'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: '\u0110\u1ed9 s\u00e1ng',
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
                        vi: 'C\u01b0\u1eddng \u0111\u1ed9 s\u00e1ng',
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
            title: flashyBoothText(context, vi: '\u0110en tr\u1eafng', en: 'B/W'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: '\u0110en tr\u1eafng',
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
                        vi: 'M\u1ee9c \u0111en tr\u1eafng',
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
            title: flashyBoothText(context, vi: 'L\u1eadt ngang', en: 'Flip H'),
            subtitle: flashyBoothSecondaryText(
              context,
              vi: 'L\u1eadt ngang',
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

  Widget _buildAdjustmentTool({
    required String title,
    required String subtitle,
    required String label,
    required FilterEnum activeType,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required VoidCallback onReset,
    String? valueLabel,
  }) {
    return Column(
      children: [
        _EditToolButton(
          title: title,
          subtitle: subtitle,
          selected: _activeAdjustment == activeType,
          onTap: () {
            setState(() {
              _activeAdjustment = activeType;
            });
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _activeAdjustment == activeType
              ? Padding(
                  key: ValueKey('${activeType.name}-slider'),
                  padding: EdgeInsets.only(top: 12.h),
                  child: _AdjustmentSlider(
                    label: label,
                    valueLabel: valueLabel ?? '${value.round()}',
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: onChanged,
                    onReset: onReset,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPresetFilters() {
    if (provider.presetCategory.isEmpty) {
      return const SizedBox.shrink();
    }
    final categoryIndex = provider.currentPresetCategoryIndex.clamp(
      0,
      provider.presetCategory.length - 1,
    );
    final presets = provider.presetCategory[categoryIndex].presets;
    if (presets.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          flashyBoothText(context, vi: 'B\u1ed9 l\u1ecdc', en: 'Presets'),
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: FlashyBoothColors.pink,
          ),
        ),
        12.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            presets.length > 8 ? 8 : presets.length,
            (index) {
              final preset = presets[index];
              final selected = provider.currentFilterIndex == index;
              return _PresetFilterChip(
                label: preset.presetName,
                selected: selected,
                onTap: () {
                  provider.changeCurrentFilterIndex(index);
                  setState(() {
                    _activeAdjustment = null;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFramePreview({
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
                  child: _buildImageFromPath(
                    sceneBackgroundPath,
                    key: ValueKey('bg_top_$sceneBackgroundPath'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageFromPath(String imagePath, {Key? key}) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        key: key,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      );
    }
    return Image.file(
      File(imagePath),
      key: key,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
    );
  }

  Widget _buildBackgroundLayer(String sceneBackgroundPath) {
    return _buildImageFromPath(sceneBackgroundPath, key: ValueKey(sceneBackgroundPath));
  }

  Widget _buildPhotoLayer() {
    return LayoutBuilder(
      builder: (context, constraint) {
        final render = _resolveRenderMetrics(
          Size(constraint.maxWidth, constraint.maxHeight),
        );
        final areas = _effectiveTransparentAreas;
        final slotCount = math.min(
          areas.length,
          appState.imageParam.images.length,
        );
        return Stack(
          children: List.generate(slotCount, (i) {
            final imagePath = appState.imageParam.images[i];
            final width = areas[i][2] * render.scaleWidth;
            final height = areas[i][3] * render.scaleHeight;
            _innerTransparentSize = Size(width, height);

            return Positioned(
              left: render.offsetX + areas[i][0] * render.scaleWidth,
              top: render.offsetY + areas[i][1] * render.scaleHeight,
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
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: CommonShaderImage(
                            effect: provider.effect,
                            imagePath: imagePath,
                          ).flip(isFlip: appState.imageParam.isFlipped),
                        ),
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
                  vi: 'Ch\u1ecdn n\u1ec1n',
                  en: 'Select Background',
                ),
                subtitle: flashyBoothSecondaryText(
                  context,
                  vi: 'Ch\u1ecdn n\u1ec1n',
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
                crossAxisCount: 2,
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
              flashyBoothText(context, vi: 'In \u1ea3nh', en: 'Print'),
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
            Text(flashyBoothTextRead(context, vi: 'Th\u00f4ng b\u00e1o', en: 'Notice')),
        description: Text(
          flashyBoothTextRead(
            context,
            vi: 'H\u00e3y ch\u1ecdn n\u1ec1n tr\u01b0\u1edbc khi ti\u1ebfp t\u1ee5c',
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
    if (normalized.isEmpty || normalized.toLowerCase() == 'm\u1eb7c \u0111\u1ecbnh') {
      return flashyBoothText(context, vi: 'M\u1eb7c \u0111\u1ecbnh', en: 'Default');
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

class _PresetFilterChip extends StatelessWidget {
  const _PresetFilterChip({
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
          constraints: BoxConstraints(minWidth: 76.w),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          decoration: BoxDecoration(
            border: Border.all(color: FlashyBoothColors.pink, width: 1.4.w),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            label.isEmpty ? 'Filter' : label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 12.sp,
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
                        key: ValueKey(path),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        gaplessPlayback: true,
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
