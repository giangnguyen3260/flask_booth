import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/resources/app_theme_palette.dart';

ThemeData buildAppThemeData() {
  return ThemeData(
    fontFamily: 'Lexend',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppThemePalette.seedColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppThemePalette.scaffoldBackgroundColor,
    primaryColor: AppThemePalette.primaryColor,
    dividerColor: AppThemePalette.dividerColor,
    textTheme: Typography.blackMountainView.apply(
      bodyColor: AppThemePalette.textColor,
      displayColor: AppThemePalette.textColor,
      fontFamily: 'Lexend',
    ),
    primaryTextTheme: Typography.blackMountainView.apply(
      bodyColor: AppThemePalette.textColor,
      displayColor: AppThemePalette.textColor,
      fontFamily: 'Lexend',
    ),
    iconTheme: IconThemeData(color: AppThemePalette.iconColor),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppThemePalette.primaryColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((_) {
          return AppThemePalette.buttonBackgroundColor;
        }),
        shape: WidgetStateProperty.resolveWith((_) {
          return RoundedRectangleBorder(
            side: BorderSide(color: AppThemePalette.borderColor, width: 1.h),
            borderRadius: BorderRadius.circular(40.r),
          );
        }),
        elevation: WidgetStateProperty.resolveWith((_) {
          return 0;
        }),
        padding: WidgetStateProperty.resolveWith((_) {
          return EdgeInsets.symmetric(vertical: 32.h, horizontal: 28.w);
        }),
        foregroundColor: WidgetStateColor.resolveWith((_) {
          return AppThemePalette.buttonForegroundColor;
        }),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.resolveWith((_) {
          return 0;
        }),
        backgroundColor: WidgetStateColor.resolveWith((_) {
          return AppThemePalette.buttonBackgroundColor;
        }),
        padding: WidgetStateProperty.resolveWith((_) {
          return EdgeInsets.zero;
        }),
        shape: WidgetStateProperty.resolveWith((_) {
          return RoundedRectangleBorder(
            side: BorderSide(color: AppThemePalette.primaryColor, width: 1.h),
            borderRadius: BorderRadius.circular(40.r),
          );
        }),
        foregroundColor: WidgetStateColor.resolveWith((_) {
          return AppThemePalette.buttonForegroundColor;
        }),
      ),
    ),
  );
}
