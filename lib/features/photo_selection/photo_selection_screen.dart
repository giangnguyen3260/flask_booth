import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:project_l/common/extensions/widget_extensions.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/directory_utils.dart';
import 'package:project_l/common/util/frame_overlay_mask_utils.dart';
import 'package:project_l/features/photo_selection/provider/photo_selection_screen_listen_state.dart';
import 'package:project_l/features/photo_selection/provider/photo_selection_screen_provider.dart';
import 'package:project_l/gen/assets.gen.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/components/common_image_file.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class PhotoSelectionScreen extends StatefulWidget {
  final Map<String, String> files;

  const PhotoSelectionScreen({super.key, required this.files});

  @override
  State<PhotoSelectionScreen> createState() => _PhotoSelectionScreenState();
}

class _PhotoSelectionScreenState extends BasePageState<
    PhotoSelectionListenState, PhotoSelectionProvider, PhotoSelectionScreen> {
  final ScrollController _scrollController = ScrollController();
  final FrameOverlayMaskUtils _frameOverlayMaskUtils = FrameOverlayMaskUtils();
  bool _didPrecacheNextScreenAssets = false;
  bool _didLogFirstFrame = false;
  bool _isLoadingFallbackImages = false;
  List<String> _defaultSampleImages = [];

  late final List<List<double>> _displayTransparentAreas =
      appState.imageParam.selectedFrame.getDisplayTransparentAreas(
    fallbackCount: max(
      appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 0,
      widget.files.length,
    ),
  );

  bool get _hasRealCapturedImages => widget.files.isNotEmpty;

  List<String> get _effectiveImagePaths => _hasRealCapturedImages
      ? widget.files.keys.toList()
      : _defaultSampleImages;

  Map<String, String> get _effectiveFiles {
    if (_hasRealCapturedImages) {
      return widget.files;
    }
    return {
      for (final imagePath in _defaultSampleImages) imagePath: imagePath,
    };
  }

  @override
  void afterFirstBuild() {
    logD(
      'PhotoSelectionScreen init: files=${widget.files.length}, displayAreas=${_displayTransparentAreas.length}, frame=${appState.imageParam.selectedFrame.frameCd}',
    );
    provider.init(numPictures: _displayTransparentAreas.length);
    if (!_hasRealCapturedImages) {
      unawaited(_loadDefaultSampleImages());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didPrecacheNextScreenAssets) {
        return;
      }
      _didPrecacheNextScreenAssets = true;
      unawaited(_precacheNextScreenAssets());
    });

    super.afterFirstBuild();
  }

  @override
  bool allowToBack(PhotoSelectionProvider provider) {
    return false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
  int countDuration() {
    return getCounterAtIndex(6);
  }

  @override
  bool isShowNext(PhotoSelectionProvider provider) {
    return false;
  }

  @override
  void onTimeEnd() {
    if (provider.onEnd(originalData: _effectiveFiles)) {
      navigator.replace(BackgroundSelectionRoute());
    }
  }

  @override
  void onNext(PhotoSelectionProvider provider) {
    super.onNext(provider);
    final stopwatch = Stopwatch()..start();
    logD(
      'PERF PhotoSelection.onNext start selected=${provider.tempData.where((e) => e.isNotEmpty).length}/${provider.tempData.length} files=${_effectiveFiles.length}',
    );
    if (provider.onNext(originalData: _effectiveFiles)) {
      logD(
        'PERF PhotoSelection.onNext providerDone elapsed=${stopwatch.elapsedMilliseconds}ms',
      );
      context.replaceRoute(BackgroundSelectionRoute());
      logD(
        'PERF PhotoSelection.onNext routeRequested elapsed=${stopwatch.elapsedMilliseconds}ms',
      );
    } else {
      logD(
        'PERF PhotoSelection.onNext blocked elapsed=${stopwatch.elapsedMilliseconds}ms',
      );
    }
  }

  Future<void> _loadDefaultSampleImages() async {
    if (_isLoadingFallbackImages || _defaultSampleImages.isNotEmpty) {
      return;
    }

    setState(() {
      _isLoadingFallbackImages = true;
    });

    try {
      final assetBytes =
          (await rootBundle.load('KHUNG TRƠN TRẮNG/demo_layout.jpg'))
              .buffer
              .asUint8List();
      final folder = await DirectoryUtils.documentDirectory(
        parentFolder: 'photo_selection_defaults',
      );
      final samples = <String>[];
      for (int i = 1; i <= 8; i++) {
        final filePath = path.join(folder, 'sample_$i.jpg');
        final file = File(filePath);
        if (!file.existsSync()) {
          await file.writeAsBytes(assetBytes);
        }
        samples.add(file.path);
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _defaultSampleImages = samples;
      });
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFallbackImages = false;
        });
      }
    }
  }

  Future<void> _precacheNextScreenAssets() async {
    final stopwatch = Stopwatch()..start();
    final frame = appState.imageParam.selectedFrame;
    final candidates = <String>{
      if ((frame.frameUrlTempDis ?? '').isNotEmpty) frame.frameUrlTempDis!,
      if ((frame.frameUrl ?? '').isNotEmpty) frame.frameUrl!,
    };

    for (final backgroundInfo in frame.backgroundInfo ?? []) {
      if ((backgroundInfo.bgCateIcon ?? '').isNotEmpty) {
        candidates.add(backgroundInfo.bgCateIcon!);
      }
      for (final background in backgroundInfo.background ?? []) {
        if ((background.bgUrl ?? '').isNotEmpty) {
          candidates.add(background.bgUrl!);
        }
      }
    }

    logD(
      'PERF PhotoSelection.precache start candidates=${candidates.length}',
    );
    for (final imagePath in candidates) {
      try {
        if (!mounted) {
          return;
        }
        await precacheImage(FileImage(File(imagePath)), context);
      } catch (_) {
        // Ignore prewarm failures. The next screen still has fallback paths.
      }
    }
    final frameOverlaySourcePath =
        frame.frameUrlTempDis ?? frame.frameUrl ?? '';
    if (frameOverlaySourcePath.isNotEmpty) {
      try {
        await _frameOverlayMaskUtils.resolveMaskedOverlayPath(
          frameOverlaySourcePath,
        );
      } catch (_) {
        // Ignore mask prewarm failures. The edit screen can resolve it later.
      }
    }
    logD(
      'PERF PhotoSelection.precache end elapsed=${stopwatch.elapsedMilliseconds}ms',
    );
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    final buildStopwatch = Stopwatch()..start();
    if (!_didLogFirstFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _didLogFirstFrame = true;
        logD(
          'PERF PhotoSelection.firstFrame elapsed=${buildStopwatch.elapsedMilliseconds}ms files=${_effectiveImagePaths.length}',
        );
      });
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final selectedCount =
            provider.tempData.where((element) => element.isNotEmpty).length;
        final requiredCount = provider.tempData.length;
        final canContinue = selectedCount == requiredCount && requiredCount > 0;
        final sidePanelWidth =
            min(330.w, max(286.w, constraints.maxWidth * 0.18));
        final contentLeft = max(96.w, constraints.maxWidth * 0.055);
        final contentRight =
            sidePanelWidth + max(128.w, constraints.maxWidth * 0.08);
        return Stack(
          children: [
            const FlashyBoothReferenceBackground(),
            const FlashyBoothStepBar(currentIndex: 6),
            Positioned(
              top: 36.h,
              right: 72.w,
              child: const FlashyBoothLanguagePill(),
            ),
            Positioned(
              top: 50.h,
              left: contentLeft,
              right: contentRight,
              child: _PhotoSelectionTitle(),
            ),
            Positioned(
              top: 152.h,
              left: contentLeft,
              right: contentRight,
              bottom: 46.h,
              child: _isLoadingFallbackImages && _defaultSampleImages.isEmpty
                  ? Center(
                      child: Text(
                        flashyBoothText(
                          context,
                          vi: 'Đang tạo ảnh mẫu...',
                          en: 'Preparing sample photos...',
                        ),
                        style: style32400.copyWith(
                          color: FlashyBoothColors.pink,
                        ),
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(right: 26.w, bottom: 20.h),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 390.w,
                          mainAxisExtent: 318.h,
                          mainAxisSpacing: 30.h,
                          crossAxisSpacing: 28.w,
                        ),
                        itemCount: _effectiveImagePaths.length,
                        itemBuilder: (context, index) {
                          final image = _effectiveImagePaths[index];
                          final selectedIndex =
                              provider.tempData.indexOf(image);
                          return _ShotTile(
                            imagePath: image,
                            index: index,
                            selectedIndex: selectedIndex,
                            isFlip: provider.isFlip,
                            onTap: () => provider.selectImage(
                              imagePath: image,
                            ),
                          );
                        },
                      ),
                    ),
            ),
            Positioned(
              top: 136.h,
              right: max(86.w, constraints.maxWidth * 0.06),
              bottom: 170.h,
              child: SizedBox(
                width: sidePanelWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      flashyBoothText(
                        context,
                        vi: 'Nhấn ảnh để hủy chọn',
                        en: 'Tap photo to deselect',
                      ),
                      style: style24400.copyWith(
                        color: FlashyBoothColors.pinkLight,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      flashyBoothSecondaryText(
                        context,
                        vi: 'Nhấn ảnh để hủy chọn',
                        en: 'Tap photo to deselect',
                      ),
                      style: style24400.copyWith(
                        color: FlashyBoothColors.pinkLight,
                        fontSize: 17.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: _SelectedSlotsPanel(
                        selectedImages: provider.tempData,
                        selectedSlotIndex: provider.selectedSlotIndex,
                        isFlip: provider.isFlip,
                        onSlotTap: provider.selectSlot,
                        onImageTap: provider.removeImageAt,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      flashyBoothText(
                        context,
                        vi: '$selectedCount / $requiredCount ảnh đã chọn',
                        en: '$selectedCount / $requiredCount selected',
                      ),
                      textAlign: TextAlign.center,
                      style: style24400.copyWith(
                        color: FlashyBoothColors.pinkLight,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: max(108.w, constraints.maxWidth * 0.07),
              bottom: 44.h,
              child: FlashyBoothRoundNavButton(
                label: flashyBoothText(context, vi: 'Sau', en: 'Next'),
                subLabel: flashyBoothSecondaryText(
                  context,
                  vi: 'Sau',
                  en: 'Next',
                ),
                enabled: canContinue,
                onTap: () => onNext(provider),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PhotoSelectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: flashyBoothText(
                  context,
                  vi: 'Vui lòng chọn ảnh ',
                  en: 'Select photos ',
                ),
                style: style5272400.copyWith(
                  color: FlashyBoothColors.pink,
                  fontSize: 50.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: flashyBoothText(
                  context,
                  vi: '(Có thể chọn trùng ảnh)',
                  en: '(Duplicates OK)',
                ),
                style: style24400.copyWith(
                  color: FlashyBoothColors.pinkLight,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          flashyBoothSecondaryText(
            context,
            vi: 'Vui lòng chọn ảnh (Có thể chọn trùng ảnh)',
            en: 'Select photos (Duplicates OK)',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style24400.copyWith(
            color: FlashyBoothColors.pinkLight,
            fontSize: 22.sp,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ShotTile extends StatelessWidget {
  const _ShotTile({
    required this.imagePath,
    required this.index,
    required this.selectedIndex,
    required this.isFlip,
    required this.onTap,
  });

  final String imagePath;
  final int index;
  final int selectedIndex;
  final bool isFlip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex >= 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isSelected
              ? FlashyBoothColors.pink
              : FlashyBoothColors.pink.withValues(alpha: 0.08),
          width: isSelected ? 2.4.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(
              alpha: isSelected ? 0.16 : 0.08,
            ),
            blurRadius: isSelected ? 26.r : 18.r,
            offset: Offset(0, isSelected ? 10.h : 7.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CommonImageFile(
                          widgetWidth: double.infinity,
                          widgetHeight: double.infinity,
                          fit: BoxFit.cover,
                          path: imagePath,
                        ).flip(isFlip: isFlip),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 38.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.32),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Shot ${index + 1}',
                          style: style20400.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                FlashyBoothColors.pink.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: FlashyBoothColors.pink,
                              width: 4.w,
                            ),
                          ),
                        ),
                      ),
                    if (isSelected)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: _OrderBadge(value: selectedIndex + 1),
                      ),
                  ],
                ),
              ),
            ),
            8.verticalSpace,
            _RetakePill(),
          ],
        ),
      ),
    );
  }
}

class _RetakePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132.w,
      height: 34.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: FlashyBoothColors.pink, width: 1.5.w),
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(alpha: 0.12),
            blurRadius: 7.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.redoIc.svg(
            width: 12.w,
            colorFilter: ColorFilter.mode(
              FlashyBoothColors.pink,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            flashyBoothText(context, vi: 'Chụp lại', en: 'Retake'),
            style: style20400.copyWith(
              color: FlashyBoothColors.pink,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedSlotsPanel extends StatelessWidget {
  const _SelectedSlotsPanel({
    required this.selectedImages,
    required this.selectedSlotIndex,
    required this.isFlip,
    required this.onSlotTap,
    required this.onImageTap,
  });

  final List<String> selectedImages;
  final int? selectedSlotIndex;
  final bool isFlip;
  final void Function({required int index}) onSlotTap;
  final void Function({required int index}) onImageTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.14),
          width: 1.4.w,
        ),
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(alpha: 0.10),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: List.generate(selectedImages.length, (index) {
          final image = selectedImages[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: index == selectedImages.length - 1 ? 0 : 8.h,
              ),
              child: _SelectedSlotTile(
                imagePath: image,
                order: index + 1,
                isActive: selectedSlotIndex == index,
                isFlip: isFlip,
                onTap: image.isEmpty
                    ? () => onSlotTap(index: index)
                    : () => onImageTap(index: index),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SelectedSlotTile extends StatelessWidget {
  const _SelectedSlotTile({
    required this.imagePath,
    required this.order,
    required this.isActive,
    required this.isFlip,
    required this.onTap,
  });

  final String imagePath;
  final int order;
  final bool isActive;
  final bool isFlip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagePath.isEmpty)
              Container(
                color: const Color(0xFFE4E0D9),
                alignment: Alignment.center,
                child: Text(
                  '+',
                  style: style24400.copyWith(
                    color: Colors.black.withValues(alpha: 0.20),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            else
              CommonImageFile(
                widgetWidth: double.infinity,
                widgetHeight: double.infinity,
                fit: BoxFit.cover,
                path: imagePath,
              ).flip(isFlip: isFlip),
            if (isActive || imagePath.isNotEmpty)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: FlashyBoothColors.pink,
                      width: isActive ? 3.w : 0,
                    ),
                  ),
                ),
              ),
            if (imagePath.isNotEmpty)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: _OrderBadge(value: order),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderBadge extends StatelessWidget {
  const _OrderBadge({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: FlashyBoothColors.pink,
        shape: BoxShape.circle,
      ),
      child: Text(
        value.toString(),
        style: style20400.copyWith(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
