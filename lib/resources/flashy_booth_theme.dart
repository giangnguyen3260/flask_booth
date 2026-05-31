import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/provider/app_state.dart';
import 'package:project_l/resources/app_theme_palette.dart';
import 'package:provider/provider.dart';

class FlashyBoothColors {
  static Color get navy => AppThemePalette.primaryColor;
  static Color get cream => AppThemePalette.scaffoldBackgroundColor;
  static Color get creamLight => AppThemePalette.scaffoldBackgroundColor;
  static Color get muted => AppThemePalette.textColor.withValues(alpha: 0.62);
  static Color get pink => AppThemePalette.primaryColor;
  static Color get pinkLight =>
      AppThemePalette.primaryColor.withValues(alpha: 0.42);
  static Color get pinkPale =>
      AppThemePalette.primaryColor.withValues(alpha: 0.12);
  static const Color success = Color(0xFF1E7A45);
  static const Color danger = Color(0xFFD32F2F);
  static const Color white = Colors.white;
}

bool flashyBoothIsVietnamese(BuildContext context) {
  return context.read<AppState>().locate.languageCode == 'vi';
}

String flashyBoothText(
  BuildContext context, {
  required String vi,
  required String en,
}) {
  return flashyBoothIsVietnamese(context) ? vi : en;
}

String flashyBoothSecondaryText(
  BuildContext context, {
  required String vi,
  required String en,
}) {
  return flashyBoothIsVietnamese(context) ? en : vi;
}

String flashyBoothTextRead(
  BuildContext context, {
  required String vi,
  required String en,
}) {
  final languageCode = context.read<AppState>().locate.languageCode;
  return languageCode == 'vi' ? vi : en;
}

class FlashyBoothStepBar extends StatelessWidget {
  const FlashyBoothStepBar({
    super.key,
    required this.currentIndex,
    this.total = 9,
  });

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Row(
        children: List.generate(total, (index) {
          return Expanded(
            child: Container(
              height: 7.h,
              margin: EdgeInsets.only(right: index == total - 1 ? 0 : 3.w),
              decoration: BoxDecoration(
                color: index <= currentIndex
                    ? FlashyBoothColors.navy
                    : FlashyBoothColors.navy.withValues(alpha: 0.18),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(3.r),
                  bottomRight: Radius.circular(3.r),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FlashyBoothAccentBackground extends StatelessWidget {
  const FlashyBoothAccentBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -24.h,
              right: -100.w,
              child: Transform.rotate(
                angle: -18 * math.pi / 180,
                child: Container(
                  width: 580.w,
                  height: 52.h,
                  color: FlashyBoothColors.navy,
                ),
              ),
            ),
            Positioned(
              top: 38.h,
              right: -130.w,
              child: Transform.rotate(
                angle: -18 * math.pi / 180,
                child: Container(
                  width: 560.w,
                  height: 18.h,
                  color: FlashyBoothColors.navy.withValues(alpha: 0.85),
                ),
              ),
            ),
            Positioned(
              bottom: -18.h,
              left: -100.w,
              child: Transform.rotate(
                angle: -2.5 * math.pi / 180,
                child: Container(
                  width: 1300.w,
                  height: 28.h,
                  color: FlashyBoothColors.navy,
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              left: -100.w,
              child: Transform.rotate(
                angle: -2.5 * math.pi / 180,
                child: Container(
                  width: 1000.w,
                  height: 14.h,
                  color: FlashyBoothColors.navy.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashyBoothReferenceBackground extends StatelessWidget {
  const FlashyBoothReferenceBackground({
    super.key,
    this.showTopRightRibbon = false,
  });

  final bool showTopRightRibbon;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(color: FlashyBoothColors.cream),
        child: CustomPaint(
          painter: _FlashyBoothReferencePainter(
            showTopRightRibbon: showTopRightRibbon,
          ),
        ),
      ),
    );
  }
}

class FlashyBoothLanguagePill extends StatelessWidget {
  const FlashyBoothLanguagePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AppState, String>(
      selector: (_, appState) => appState.locate.languageCode,
      builder: (context, languageCode, child) {
        return Container(
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            color: const Color(0xFFDCD6DC).withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FlashyBoothLanguagePillItem(
                label: 'VI',
                selected: languageCode == 'vi',
                onTap: () => context.read<AppState>().updateLanguageCode('vi'),
              ),
              _FlashyBoothLanguagePillItem(
                label: 'EN',
                selected: languageCode == 'en',
                onTap: () => context.read<AppState>().updateLanguageCode('en'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FlashyBoothScreenTitle extends StatelessWidget {
  const FlashyBoothScreenTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.align = TextAlign.left,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleSize,
    this.subtitleSize,
    this.subtitleItalic = false,
  });

  final String title;
  final String subtitle;
  final TextAlign align;
  final CrossAxisAlignment crossAxisAlignment;
  final double? titleSize;
  final double? subtitleSize;
  final bool subtitleItalic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          textAlign: align,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: titleSize ?? 40.sp,
            fontWeight: FontWeight.w900,
            color: FlashyBoothColors.pink,
            height: 1.05,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: align,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: subtitleSize ?? 22.sp,
            fontStyle: subtitleItalic ? FontStyle.italic : FontStyle.normal,
            fontWeight: subtitleItalic ? FontWeight.w700 : FontWeight.w500,
            color: FlashyBoothColors.pink.withValues(alpha: 0.72),
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _FlashyBoothLanguagePillItem extends StatelessWidget {
  const _FlashyBoothLanguagePillItem({
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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(36.r),
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(36.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: selected ? FlashyBoothColors.pink : Colors.transparent,
            borderRadius: BorderRadius.circular(36.r),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: FlashyBoothColors.pink.withValues(alpha: 0.28),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : FlashyBoothColors.pink,
              letterSpacing: 1,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class FlashyBoothRoundNavButton extends StatelessWidget {
  const FlashyBoothRoundNavButton({
    super.key,
    required this.label,
    required this.subLabel,
    required this.onTap,
    this.alignment = Alignment.center,
    this.enabled = true,
  });

  final String label;
  final String subLabel;
  final VoidCallback onTap;
  final Alignment alignment;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? FlashyBoothColors.pink
          : FlashyBoothColors.pink.withValues(alpha: 0.38),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 104.w,
          height: 104.w,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  subLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.72),
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

class FlashyBoothCircleAction extends StatelessWidget {
  const FlashyBoothCircleAction({
    super.key,
    required this.label,
    required this.subLabel,
    required this.onTap,
    this.disabled = false,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final String subLabel;
  final VoidCallback? onTap;
  final bool disabled;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = !disabled && !isLoading && onTap != null;
    return Material(
      color: enabled
          ? FlashyBoothColors.navy
          : FlashyBoothColors.navy.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 112.w,
          height: 112.w,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: FlashyBoothColors.white,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: FlashyBoothColors.white,
                            size: 24.r,
                          ),
                          child: icon!,
                        ),
                        SizedBox(height: 5.h),
                      ],
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: FlashyBoothColors.white,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: FlashyBoothColors.white.withValues(alpha: 0.5),
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

class FlashyBoothWindowCard extends StatelessWidget {
  const FlashyBoothWindowCard({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shadowOffset = math.min(width * 0.035, 28.w);
    return SizedBox(
      width: width + shadowOffset,
      height: height + shadowOffset,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(30.r),
              decoration: BoxDecoration(
                color: FlashyBoothColors.creamLight,
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: Colors.black, width: 3.h),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashyBoothReferencePainter extends CustomPainter {
  const _FlashyBoothReferencePainter({required this.showTopRightRibbon});

  final bool showTopRightRibbon;

  @override
  void paint(Canvas canvas, Size size) {
    final side = Paint()..color = FlashyBoothColors.pinkPale;
    canvas.drawRect(Rect.fromLTWH(0, 0, 78, size.height), side);
    canvas.drawRect(Rect.fromLTWH(size.width - 80, 0, 80, size.height), side);

    final pink = Paint()
      ..color = FlashyBoothColors.pink
      ..style = PaintingStyle.fill;
    final pale = Paint()
      ..color = FlashyBoothColors.pinkLight.withValues(alpha: 0.72)
      ..style = PaintingStyle.fill;

    if (showTopRightRibbon) {
      _ribbon(
        canvas,
        center: Offset(size.width * 0.84, size.height * 0.045),
        width: size.width * 0.19,
        height: size.height * 0.048,
        angle: -0.28,
        paint: Paint()..color = FlashyBoothColors.pink.withValues(alpha: 0.9),
      );
      _ribbon(
        canvas,
        center: Offset(size.width * 0.85, size.height * 0.095),
        width: size.width * 0.18,
        height: size.height * 0.016,
        angle: -0.28,
        paint: pale,
      );
    }

    _sparkle(canvas, Offset(size.width * 0.89, size.height * 0.87), 18, pink);
    _sparkle(canvas, Offset(size.width * 0.94, size.height * 0.86), 8, pink);
    _sparkle(canvas, Offset(size.width * 0.875, size.height * 0.945), 9, pale);
    _sparkle(canvas, Offset(size.width * 0.125, size.height * 0.70), 8, pink);
    _bow(canvas, Offset(size.width * 0.082, size.height * 0.064), 68);
  }

  void _ribbon(
    Canvas canvas, {
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

  void _sparkle(Canvas canvas, Offset c, double r, Paint paint) {
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
    canvas.drawPath(path, paint);
  }

  void _bow(Canvas canvas, Offset c, double s) {
    final paint = Paint()
      ..color = FlashyBoothColors.pink.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx - s * 0.24, c.dy),
        width: s * 0.48,
        height: s * 0.26,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx + s * 0.24, c.dy),
        width: s * 0.48,
        height: s * 0.26,
      ),
      paint,
    );
    canvas.drawCircle(c, s * 0.065, paint);
    canvas.drawLine(c, Offset(c.dx - s * 0.18, c.dy + s * 0.42), paint);
    canvas.drawLine(c, Offset(c.dx + s * 0.18, c.dy + s * 0.42), paint);
  }

  @override
  bool shouldRepaint(covariant _FlashyBoothReferencePainter oldDelegate) {
    return oldDelegate.showTopRightRibbon != showTopRightRibbon;
  }
}
