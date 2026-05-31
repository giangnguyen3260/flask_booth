import 'package:flutter/material.dart';
import 'package:project_l/remote/models/app_data.dart';

class AppThemeConfig {
  const AppThemeConfig({
    required this.seedColor,
    required this.scaffoldBackgroundColor,
    required this.textColor,
    required this.primaryColor,
    required this.borderColor,
    required this.buttonBackgroundColor,
    required this.buttonForegroundColor,
    required this.iconColor,
    required this.dividerColor,
    required this.defaultLanguage,
  });

  factory AppThemeConfig.defaults() {
    return const AppThemeConfig(
      seedColor: Color(0xFFE85BAA),
      scaffoldBackgroundColor: Color(0xFFFFF6FB),
      textColor: Color(0xFFC94F93),
      primaryColor: Color(0xFFE85BAA),
      borderColor: Color(0xFFF0C8DA),
      buttonBackgroundColor: Colors.white,
      buttonForegroundColor: Color(0xFFE85BAA),
      iconColor: Color(0xFFE85BAA),
      dividerColor: Color(0xFFF0C8DA),
      defaultLanguage: 'vi',
    );
  }

  factory AppThemeConfig.fromAppData(AppData appData) {
    final items = appData.configInfo?.appConfig ?? [];
    AppConfigItem? themeItem;
    for (final item in items) {
      if ((item.configKey ?? '').toUpperCase() == 'THEME') {
        themeItem = item;
        break;
      }
    }
    final value = themeItem?.value ?? const <String, Object?>{};
    return AppThemeConfig.fromMap(value);
  }

  factory AppThemeConfig.fromMap(Map<String, Object?> value) {
    final defaults = AppThemeConfig.defaults();
    return AppThemeConfig(
      seedColor: _parseColor(value['seedColor'], defaults.seedColor),
      scaffoldBackgroundColor: _parseColor(
        value['scaffoldBackgroundColor'] ?? value['backgroundColor'],
        defaults.scaffoldBackgroundColor,
      ),
      textColor: _parseColor(value['textColor'], defaults.textColor),
      primaryColor: _parseColor(value['primaryColor'], defaults.primaryColor),
      borderColor: _parseColor(value['borderColor'], defaults.borderColor),
      buttonBackgroundColor: _parseColor(
        value['buttonBackgroundColor'],
        defaults.buttonBackgroundColor,
      ),
      buttonForegroundColor: _parseColor(
        value['buttonForegroundColor'],
        defaults.buttonForegroundColor,
      ),
      iconColor: _parseColor(value['iconColor'], defaults.iconColor),
      dividerColor: _parseColor(value['dividerColor'], defaults.dividerColor),
      defaultLanguage:
          _parseLanguage(value['defaultLanguage'], defaults.defaultLanguage),
    );
  }

  final Color seedColor;
  final Color scaffoldBackgroundColor;
  final Color textColor;
  final Color primaryColor;
  final Color borderColor;
  final Color buttonBackgroundColor;
  final Color buttonForegroundColor;
  final Color iconColor;
  final Color dividerColor;
  final String defaultLanguage;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppThemeConfig &&
            runtimeType == other.runtimeType &&
            seedColor.toARGB32() == other.seedColor.toARGB32() &&
            scaffoldBackgroundColor.toARGB32() ==
                other.scaffoldBackgroundColor.toARGB32() &&
            textColor.toARGB32() == other.textColor.toARGB32() &&
            primaryColor.toARGB32() == other.primaryColor.toARGB32() &&
            borderColor.toARGB32() == other.borderColor.toARGB32() &&
            buttonBackgroundColor.toARGB32() ==
                other.buttonBackgroundColor.toARGB32() &&
            buttonForegroundColor.toARGB32() ==
                other.buttonForegroundColor.toARGB32() &&
            iconColor.toARGB32() == other.iconColor.toARGB32() &&
            dividerColor.toARGB32() == other.dividerColor.toARGB32() &&
            defaultLanguage == other.defaultLanguage;
  }

  @override
  int get hashCode => Object.hash(
        seedColor.toARGB32(),
        scaffoldBackgroundColor.toARGB32(),
        textColor.toARGB32(),
        primaryColor.toARGB32(),
        borderColor.toARGB32(),
        buttonBackgroundColor.toARGB32(),
        buttonForegroundColor.toARGB32(),
        iconColor.toARGB32(),
        dividerColor.toARGB32(),
        defaultLanguage,
      );

  static Color _parseColor(Object? raw, Color fallback) {
    if (raw is int) {
      return Color(raw);
    }
    if (raw is num) {
      return Color(raw.toInt());
    }
    if (raw is String) {
      final normalized = raw.trim();
      if (normalized.isEmpty) {
        return fallback;
      }
      final hex = normalized
          .replaceAll('#', '')
          .replaceAll('0x', '')
          .replaceAll('0X', '');
      final parsed = int.tryParse(hex, radix: 16);
      if (parsed != null) {
        return hex.length <= 6 ? Color(0xFF000000 | parsed) : Color(parsed);
      }
    }
    return fallback;
  }

  static String _parseLanguage(Object? raw, String fallback) {
    final normalized = raw?.toString().trim().toLowerCase() ?? '';
    if (normalized == 'en' || normalized == 'vi') {
      return normalized;
    }
    return fallback;
  }
}
