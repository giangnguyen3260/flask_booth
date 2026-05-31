enum FilterEnum {
  brightness,
  contrast,
  saturation,
  vibrance,
  temperature,
  sepia,
  grain,
}

extension FilterExtension on FilterEnum {
  (double, double) getRange() {
    return switch (this) {
      FilterEnum.brightness => (-0.3, 0.3),
      FilterEnum.contrast => (0.5, 1.5),
      FilterEnum.saturation => (0.5, 1.5),
      FilterEnum.vibrance => (-0.3, 0.3),
      FilterEnum.temperature => (-1.0, 1.0),
      FilterEnum.sepia => (0.0, 1.0),
      FilterEnum.grain => (0.0, 0.5),
    };
  }

  double getDefaultValue() {
    return switch (this) {
      FilterEnum.brightness => 0.0,
      FilterEnum.contrast => 1.0,
      FilterEnum.saturation => 1.0,
      FilterEnum.vibrance => 0.0,
      FilterEnum.temperature => 0.0,
      FilterEnum.sepia => 0.0,
      FilterEnum.grain => 0.0,
    };
  }


  String getTitle() {
    return switch (this) {
      FilterEnum.brightness => "Độ sáng",
      FilterEnum.contrast => "Độ tương phản",
      FilterEnum.saturation => "Độ bão hòa",
      FilterEnum.vibrance => "Độ rực rỡ",
      FilterEnum.temperature => "Nhiệt độ màu",
      FilterEnum.sepia => "Hiệu ứng Sepia",
      FilterEnum.grain => "Hạt nhiễu",
    };
  }

  String getLabel(double value) {
    final (min, max) = getRange();
    final defaultValue = getDefaultValue();
    final symmetricValue = (min + max) / 2;
    const double epsilon = 0.0001; // Để tránh lỗi so sánh số thực

    // Kiểm tra tính đối xứng
    final isSymmetric = (defaultValue - symmetricValue).abs() < epsilon;

    if (isSymmetric) {
      final mappedValue = -100 + (200 * (value - min) / (max - min));
      final intValue = mappedValue.toInt();
      if (intValue == 0) return "0";
      if (intValue < 0 && intValue > -1) return "-1";
      if (intValue > 0 && intValue < 1) return "1";
      return intValue.toStringAsFixed(0);
    } else {
      final mappedValue = 100 * (value - min) / (max - min);
      return "${mappedValue.toInt()}";
    }
  }

  /// UI dùng scale [-100, 100] hay [0, 100]
  bool get isBidirectional => switch (this) {
    FilterEnum.brightness => true,
    FilterEnum.contrast => true,
    FilterEnum.saturation => true,
    FilterEnum.vibrance => true,
    FilterEnum.temperature => true,
    FilterEnum.sepia => false,
    FilterEnum.grain => false,
  };

  /// Convert UI value to actual shader value
  double fromUIValue(double uiValue) {
    final (min, max) = getRange();
    if (isBidirectional) {
      return min + ((uiValue + 100) / 200.0) * (max - min);
    } else {
      return min + (uiValue / 100.0) * (max - min);
    }
  }

  /// Convert shader value to UI value
  double toUIValue(double actualValue) {
    final (min, max) = getRange();
    if (isBidirectional) {
      return (((actualValue - min) / (max - min)) * 200.0 - 100);
    } else {
      return (((actualValue - min) / (max - min)) * 100.0);
    }
  }

  bool getExpand() {
    switch (this) {
      case FilterEnum.brightness:
      case FilterEnum.contrast:
      case FilterEnum.saturation:
      case FilterEnum.vibrance:
      case FilterEnum.temperature:
        return false;
      case FilterEnum.sepia:
      case FilterEnum.grain:
        return true;
    }
  }
}
