import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/features/shooting_guide_screen/provider/shooting_guide_screen_listen_state.dart';
import 'package:project_l/features/shooting_guide_screen/provider/shooting_guide_screen_provider.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class ShootingGuideScreenScreen extends StatefulWidget {
  const ShootingGuideScreenScreen({super.key});

  @override
  State<ShootingGuideScreenScreen> createState() =>
      _ShootingGuideScreenScreenState();
}

class _ShootingGuideScreenScreenState extends BasePageState<
    ShootingGuideScreenListenState,
    ShootingGuideScreenProvider,
    ShootingGuideScreenScreen> {
  @override
  bool isShowCountDown() {
    return false;
  }

  @override
  bool isFooterEnabled() {
    return false;
  }

  @override
  bool allowToBack(ShootingGuideScreenProvider provider) {
    return false;
  }

  @override
  int countDuration() {
    return getCounterAtIndex(4);
  }

  @override
  void onTimeEnd() {
    _startShooting();
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    final frameSetting = appState.imageParam.selectedFrame.frameSetting;
    final photoCount = frameSetting?.shortCount ?? frameSetting?.numOfPhotos ?? 10;
    final shotTime = frameSetting?.timePerShot ?? 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = (constraints.maxWidth * 0.62).clamp(680.0, 980.0);
        final isCompact = constraints.maxHeight < 760;
        return Stack(
          children: [
            const FlashyBoothReferenceBackground(),
            const FlashyBoothStepBar(currentIndex: 4),
            Positioned(
              top: 30.h,
              right: 112.w,
              child: const FlashyBoothLanguagePill(),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'READY GO!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: isCompact ? 106.sp : 140.sp,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color:
                                FlashyBoothColors.pink.withValues(alpha: 0.08),
                            height: 1,
                          ),
                        ),
                        Text(
                          'READY GO!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: isCompact ? 76.sp : 104.sp,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: FlashyBoothColors.pink,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isCompact ? 44.h : 60.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ReadyInfoCard(
                          label: flashyBoothText(
                            context,
                            vi: 'Số lần chụp',
                            en: 'Shots',
                          ),
                          value: flashyBoothText(
                            context,
                            vi: '$photoCount lần',
                            en: '$photoCount shots',
                          ),
                        ),
                        SizedBox(width: 38.w),
                        _ReadyInfoCard(
                          label: flashyBoothText(
                            context,
                            vi: 'Thời gian / lần',
                            en: 'Time / shot',
                          ),
                          value: flashyBoothText(
                            context,
                            vi: '$shotTime giây',
                            en: '$shotTime sec',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      flashyBoothText(
                        context,
                        vi: 'Tự động chụp khi hết thời gian',
                        en: 'Auto capture when time is up',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style24400.copyWith(
                        color: FlashyBoothColors.pinkLight,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: isCompact ? 34.h : 46.h),
                    _GetReadyButton(onTap: _startShooting),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startShooting() {
    navigator.replaceAll([StandByRoute(), ShootingRoute()]);
  }
}

class _ReadyInfoCard extends StatelessWidget {
  const _ReadyInfoCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      height: 154.h,
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.22),
          width: 2.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style24400.copyWith(
              color: FlashyBoothColors.pinkLight,
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style4272400.copyWith(
              color: FlashyBoothColors.pink,
              fontSize: 44.sp,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _GetReadyButton extends StatelessWidget {
  const _GetReadyButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlashyBoothColors.pink,
      borderRadius: BorderRadius.circular(40.r),
      elevation: 16,
      shadowColor: FlashyBoothColors.pink.withValues(alpha: 0.24),
      child: InkWell(
        borderRadius: BorderRadius.circular(40.r),
        onTap: onTap,
        child: SizedBox(
          width: 426.w,
          height: 110.h,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  flashyBoothText(
                    context,
                    vi: 'Chuẩn bị chụp',
                    en: 'Get ready',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style32500.copyWith(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  flashyBoothSecondaryText(
                    context,
                    vi: 'Chuẩn bị chụp',
                    en: 'Get ready',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style24400.copyWith(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
