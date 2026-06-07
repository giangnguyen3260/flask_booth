import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/money_format.dart';
import 'package:project_l/features/choose_frame/provider/choose_frame_listen_state.dart';
import 'package:project_l/features/choose_frame/provider/choose_frame_provider.dart';
import 'package:project_l/remote/models/app_data.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class ChooseFrameScreen extends StatefulWidget {
  const ChooseFrameScreen({super.key});

  @override
  State<ChooseFrameScreen> createState() => _ChooseFrameScreenState();
}

class _ChooseFrameScreenState extends BasePageState<ChooseFrameListenState,
    ChooseFrameProvider, ChooseFrameScreen> {
  final ScrollController scrollController = ScrollController();
  static const int _rowsPerPage = 2;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool isShowNext(ChooseFrameProvider provider) {
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
  bool allowToBack(ChooseFrameProvider provider) {
    return false;
  }

  @override
  int countDuration() {
    return getCounterAtIndex(1);
  }

  @override
  void onNext(ChooseFrameProvider provider) {
    super.onNext(provider);
    appState.updateFrame(appState.frameInfos[provider.selectedFrame]);
    navigator.push(ChooseFrameQuantityRoute()).then((_) {
      resetTimer();
    });
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final frames = appState.frameInfos;
        final viewportWidth = math.min(constraints.maxWidth * 0.88, 1280.w);
        final framesPerRow = frames.length <= 6 ? 3 : 4;
        final itemsPerPage = framesPerRow * _rowsPerPage;
        final frameListTop = math.min(206.h, constraints.maxHeight * 0.25);
        final frameListHeight = math.max(
          470.h,
          math.min(570.h, constraints.maxHeight - frameListTop - 118.h),
        );
        final pageCount = (frames.length / itemsPerPage).ceil().clamp(1, 999);
        return Stack(
          children: [
            const FlashyBoothReferenceBackground(),
            const FlashyBoothStepBar(currentIndex: 0),
            Positioned(
              top: 30.h,
              right: 112.w,
              child: const FlashyBoothLanguagePill(),
            ),
            Positioned(
              top: 48.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    flashyBoothText(
                      context,
                      vi: 'Vui lòng chọn khung ảnh',
                      en: 'Please select a frame',
                    ),
                    style: style6072400.copyWith(
                      color: FlashyBoothColors.pink,
                      fontWeight: FontWeight.w900,
                      fontSize: 56.sp,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    flashyBoothSecondaryText(
                      context,
                      vi: 'Vui lòng chọn khung ảnh',
                      en: 'Select frame',
                    ),
                    style: style24400.copyWith(
                      color: FlashyBoothColors.pinkLight,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: frameListTop,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: viewportWidth,
                  height: frameListHeight,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        pageCount,
                        (pageIndex) => SizedBox(
                          width: viewportWidth,
                          child: _buildFramePage(
                            frames: frames,
                            pageIndex: pageIndex,
                            framesPerRow: framesPerRow,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 134.w,
              bottom: 40.h,
              child: FlashyBoothRoundNavButton(
                label: flashyBoothText(
                  context,
                  vi: 'Trước',
                  en: 'Back',
                ),
                subLabel: flashyBoothSecondaryText(
                  context,
                  vi: 'Trước',
                  en: 'Back',
                ),
                onTap: () => navigator.pop(),
              ),
            ),
            Positioned(
              left: math.max(170.w, constraints.maxWidth * 0.17),
              top: frameListTop + frameListHeight / 2 - 31.h,
              child: _ArrowCircle(
                icon: Icons.chevron_left_rounded,
                onTap: () {
                  final nextOffset = (scrollController.offset - 260.w)
                      .clamp(0.0, double.infinity);
                  unawaited(scrollController.animateTo(
                    nextOffset,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ));
                },
              ),
            ),
            Positioned(
              right: math.max(170.w, constraints.maxWidth * 0.17),
              top: frameListTop + frameListHeight / 2 - 31.h,
              child: _ArrowCircle(
                icon: Icons.chevron_right_rounded,
                onTap: () {
                  if (!scrollController.hasClients) {
                    return;
                  }
                  final nextOffset = (scrollController.offset + 260.w).clamp(
                    0.0,
                    scrollController.position.maxScrollExtent,
                  );
                  unawaited(scrollController.animateTo(
                    nextOffset,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ));
                },
              ),
            ),
            if (provider.selectedFrame >= 0 &&
                provider.selectedFrame < frames.length)
              Positioned(
                left: 0,
                right: 0,
                bottom: 58.h,
                child: Center(
                  child: _SelectedFrameAction(
                    frame: frames[provider.selectedFrame],
                    onTap: () => onNext(provider),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFramePage({
    required List<FramesInfo> frames,
    required int pageIndex,
    required int framesPerRow,
  }) {
    final pageStart = pageIndex * framesPerRow * _rowsPerPage;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_rowsPerPage, (rowIndex) {
        final rowStart = pageStart + rowIndex * framesPerRow;
        final rowEnd = math.min(rowStart + framesPerRow, frames.length);
        if (rowStart >= frames.length) {
          return SizedBox(height: 272.h);
        }
        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex == 0 ? 22.h : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(rowEnd - rowStart, (indexInRow) {
              final frameIndex = rowStart + indexInRow;
              return Padding(
                padding: EdgeInsets.only(
                  right: indexInRow == rowEnd - rowStart - 1
                      ? 0
                      : (framesPerRow == 3 ? 52.w : 34.w),
                ),
                child: _renderFrame(frames[frameIndex], frameIndex),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _renderFrame(FramesInfo frame, int index) {
    final selected = provider.selectedFrame == index;
    final previewWidth = 172.w;
    final previewHeight = 178.h;
    final label = (frame.frameCd ?? 'Frame').replaceAll('_', ' ');
    return GestureDetector(
      onTap: () {
        provider.selectFrame(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 222.w,
        height: 272.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.52),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? FlashyBoothColors.pink
                : FlashyBoothColors.pink.withValues(alpha: 0.08),
            width: selected ? 3.w : 1.2.w,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: FlashyBoothColors.pink.withValues(alpha: 0.18),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: previewWidth,
              height: previewHeight,
              child: _FramePreviewSurface(
                child: _FrameImage(frame: frame),
              ),
            ),
            10.verticalSpace,
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: style24400.copyWith(
                color: selected
                    ? FlashyBoothColors.pink
                    : FlashyBoothColors.pink.withValues(alpha: 0.72),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            6.verticalSpace,
            Text(
              '${_formatPrice(frame)}đ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style2432500.copyWith(
                color: FlashyBoothColors.pink,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(FramesInfo frame) {
    final price = frame.price ?? 0;
    return price.toMoney;
  }
}

class _FramePreviewSurface extends StatelessWidget {
  const _FramePreviewSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAF4),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.18),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: Center(child: child),
      ),
    );
  }
}

class _FrameImage extends StatelessWidget {
  const _FrameImage({required this.frame});

  final FramesInfo frame;

  @override
  Widget build(BuildContext context) {
    final path = frame.frameUrlTempDis ?? frame.frameUrl ?? '';
    if (path.isNotEmpty && File(path).existsSync()) {
      return Image.file(
        File(path),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      );
    }
    final slots = frame.getDisplayTransparentAreas(
      fallbackCount: frame.frameSetting?.numOfPhotos ?? 4,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD8D2D0), width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: List.generate(
            slots.length.clamp(1, 4),
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D4CE),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowCircle extends StatelessWidget {
  const _ArrowCircle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlashyBoothColors.pinkPale.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 62.w,
          height: 62.w,
          child: Icon(icon, color: Colors.white, size: 38.r),
        ),
      ),
    );
  }
}

class _SelectedFrameAction extends StatelessWidget {
  const _SelectedFrameAction({required this.frame, required this.onTap});

  final FramesInfo frame;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = (frame.frameCd ?? 'Frame').replaceAll('_', ' ');
    final price = frame.price ?? 0;
    return Material(
      color: FlashyBoothColors.pink,
      borderRadius: BorderRadius.circular(999.r),
      elevation: 14,
      shadowColor: FlashyBoothColors.pink.withValues(alpha: 0.32),
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: onTap,
        child: SizedBox(
          width: 410.w,
          height: 60.h,
          child: Center(
            child: Text(
              '$label – ${price.toMoney}đ  →',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style2432500.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 26.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
