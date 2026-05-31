import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/app_state.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/ffmpeg_utils.dart';
import 'package:project_l/features/stand_by/provider/stand_by_listen_state.dart';
import 'package:project_l/features/stand_by/provider/stand_by_provider.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';
import 'package:provider/provider.dart';

@RoutePage()
class StandByScreen extends StatefulWidget {
  const StandByScreen({super.key});

  @override
  State<StandByScreen> createState() => _StandByScreenState();
}

class _StandByScreenState
    extends BasePageState<StandByListenState, StandByProvider, StandByScreen> {
  final ffmpegUtil = GetIt.instance.get<FfmpegUtils>();
  bool _isReloading = false;

  @override
  bool isShowCountDown() => false;

  @override
  bool allowToBack(StandByProvider provider) {
    return false;
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    return Selector<AppState, bool>(
      selector: (context, provider) => provider.isInitSuccess,
      builder: (context, value, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;
            final logoCardSize = math.min(
              math.min(availableWidth * 0.31, availableHeight * 0.58),
              570.w,
            );
            final buttonWidth = math.min(availableWidth * 0.31, 540.w);
            final buttonHeight = math.min(availableHeight * 0.085, 82.h);
            return Stack(
              children: [
                const Positioned.fill(child: _SplashBackground()),
                Positioned(
                  top: 30.h,
                  right: 112.w,
                  child: const FlashyBoothLanguagePill(),
                ),
                Positioned(
                  top: 52.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: logoCardSize,
                      height: logoCardSize,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: FlashyBoothColors.pink
                                  .withValues(alpha: 0.05),
                              blurRadius: 28.r,
                              offset: Offset(0, 18.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(52.r),
                          child: Image.asset(
                            'assets/branding/flashy_booth_logo.jpg',
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 52.h + logoCardSize + 34.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _StartButton(
                      width: buttonWidth,
                      height: buttonHeight,
                      isLoading: _isReloading,
                      enabled: value,
                      onTap: () async {
                        if (!value) {
                          final success = await _reloadRemoteData();
                          if (!success) {
                            return;
                          }
                        }
                        if (appState.frameInfos.isNotEmpty) {
                          navigator.push(ChooseFrameRoute());
                          appState.reset();
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 120.w,
                  bottom: 72.h,
                  child: SizedBox(
                    width: 52.w,
                    height: 52.w,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.65),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _isReloading ? null : _reloadRemoteData,
                        child: Center(
                          child: _isReloading
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: FlashyBoothColors.pink,
                                  ),
                                )
                              : Icon(
                                  Icons.refresh_rounded,
                                  color: FlashyBoothColors.pink,
                                  size: 27.r,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _reloadRemoteData() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _isReloading = true;
    });
    try {
      await appState.reloadRemoteData();
      return true;
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              flashyBoothTextRead(
                context,
                vi: 'Không tải được dữ liệu mới từ admin',
                en: 'Could not load the latest admin data',
              ),
            ),
            backgroundColor: Colors.black,
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isReloading = false;
        });
      }
    }
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required this.width,
    required this.height,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  final double width;
  final double height;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? FlashyBoothColors.pink
          : FlashyBoothColors.pink.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(999.r),
      shadowColor: FlashyBoothColors.pink.withValues(alpha: 0.34),
      elevation: 16,
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: isLoading ? null : onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      enabled
                          ? flashyBoothText(
                              context,
                              vi: '✦ CHẠM ĐỂ BẮT ĐẦU ✦',
                              en: '✦ TAP TO START ✦',
                            )
                          : flashyBoothText(
                              context,
                              vi: '✦ CHẠM ĐỂ TẢI ✦',
                              en: '✦ TAP TO LOAD ✦',
                            ),
                      style: style40400.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: FlashyBoothColors.cream,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _SplashDecorationPainter()),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 78.w,
              color: FlashyBoothColors.pinkPale,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 80.w,
              color: FlashyBoothColors.pinkPale,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pink = Paint()
      ..color = FlashyBoothColors.pink
      ..style = PaintingStyle.fill;
    final pale = Paint()
      ..color = FlashyBoothColors.pinkLight.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    final line = Paint()
      ..color = FlashyBoothColors.pinkLight.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    void ribbon({
      required Offset center,
      required double width,
      required double height,
      required double angle,
      required Paint paint,
    }) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: width, height: height),
          const Radius.circular(1),
        ),
        paint,
      );
      canvas.restore();
    }

    ribbon(
      center: Offset(size.width * 0.84, size.height * 0.045),
      width: size.width * 0.19,
      height: size.height * 0.048,
      angle: -0.28,
      paint: pink..color = FlashyBoothColors.pink.withValues(alpha: 0.9),
    );
    ribbon(
      center: Offset(size.width * 0.85, size.height * 0.095),
      width: size.width * 0.18,
      height: size.height * 0.016,
      angle: -0.28,
      paint: pale,
    );
    ribbon(
      center: Offset(size.width * 0.34, size.height * 0.985),
      width: size.width * 0.62,
      height: size.height * 0.026,
      angle: -0.026,
      paint: pink..color = FlashyBoothColors.pink.withValues(alpha: 0.75),
    );
    ribbon(
      center: Offset(size.width * 0.26, size.height * 0.965),
      width: size.width * 0.45,
      height: size.height * 0.013,
      angle: -0.035,
      paint: pale,
    );

    void sparkle(Offset c, double r) {
      final path = Path()
        ..moveTo(c.dx, c.dy - r)
        ..lineTo(c.dx + r * 0.12, c.dy - r * 0.12)
        ..lineTo(c.dx + r, c.dy)
        ..lineTo(c.dx + r * 0.12, c.dy + r * 0.12)
        ..lineTo(c.dx, c.dy + r)
        ..lineTo(c.dx - r * 0.12, c.dy + r * 0.12)
        ..lineTo(c.dx - r, c.dy)
        ..lineTo(c.dx - r * 0.12, c.dy - r * 0.12)
        ..close();
      canvas.drawPath(path, pink);
    }

    sparkle(Offset(size.width * 0.092, size.height * 0.083), 17);
    sparkle(Offset(size.width * 0.455, size.height * 0.053), 8);
    sparkle(Offset(size.width * 0.895, size.height * 0.205), 8);
    sparkle(Offset(size.width * 0.128, size.height * 0.775), 11);
    sparkle(Offset(size.width * 0.83, size.height * 0.81), 9);

    void bow(Offset c, double s) {
      final bowPaint = Paint()
        ..color = FlashyBoothColors.pinkLight.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(c.dx - s * 0.26, c.dy),
          width: s * 0.48,
          height: s * 0.22,
        ),
        bowPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(c.dx + s * 0.26, c.dy),
          width: s * 0.48,
          height: s * 0.22,
        ),
        bowPaint,
      );
      canvas.drawCircle(c, s * 0.055, bowPaint);
      canvas.drawLine(c, Offset(c.dx - s * 0.16, c.dy + s * 0.28), bowPaint);
      canvas.drawLine(c, Offset(c.dx + s * 0.16, c.dy + s * 0.28), bowPaint);
    }

    bow(Offset(size.width * 0.168, size.height * 0.108), 52);
    bow(Offset(size.width * 0.798, size.height * 0.09), 48);
    bow(Offset(size.width * 0.102, size.height * 0.68), 42);
    bow(Offset(size.width * 0.867, size.height * 0.746), 42);

    canvas.drawLine(
      Offset(size.width * 0.19, size.height * 0.15),
      Offset(size.width * 0.19, size.height * 0.15),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
