import 'package:flutter/material.dart';
import 'package:project_l/common/models/app_theme_config.dart';
import 'package:project_l/resources/app_colors.dart';

class AppThemePalette {
  static Color seedColor = AppColors.pink;
  static Color scaffoldBackgroundColor = AppColors.blush;
  static Color textColor = AppColors.rose;
  static Color primaryColor = AppColors.pink;
  static Color borderColor = AppColors.border;
  static Color buttonBackgroundColor = Colors.white;
  static Color buttonForegroundColor = AppColors.pink;
  static Color iconColor = AppColors.pink;
  static Color dividerColor = AppColors.border;

  static void apply(AppThemeConfig config) {
    seedColor = config.seedColor;
    scaffoldBackgroundColor = config.scaffoldBackgroundColor;
    textColor = config.textColor;
    primaryColor = config.primaryColor;
    borderColor = config.borderColor;
    buttonBackgroundColor = config.buttonBackgroundColor;
    buttonForegroundColor = config.buttonForegroundColor;
    iconColor = config.iconColor;
    dividerColor = config.dividerColor;
  }

  static void reset() {
    apply(AppThemeConfig.defaults());
  }
}
