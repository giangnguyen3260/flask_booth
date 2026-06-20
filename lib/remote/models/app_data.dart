import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_l/common/util/list_utils.dart';
import 'package:project_l/common/util/string_utils.dart';

part 'app_data.freezed.dart';

part 'app_data.g.dart';

@freezed
class AppData with _$AppData {
  const factory AppData({
    @JsonKey(name: 'framesInfo') List<FramesInfo>? framesInfo,
    @JsonKey(name: 'configInfo') ConfigInfo? configInfo,
  }) = _AppData;

  factory AppData.fromJson(Map<String, Object?> json) =>
      _$AppDataFromJson(json);
}

@freezed
class ConfigInfo with _$ConfigInfo {
  const factory ConfigInfo({
    @JsonKey(name: 'timer') List<Timer>? timer,
    @JsonKey(name: 'configVersion') int? configVersion,
    @JsonKey(name: 'appConfig') List<AppConfigItem>? appConfig,
  }) = _ConfigInfo;

  factory ConfigInfo.fromJson(Map<String, Object?> json) =>
      _$ConfigInfoFromJson(json);
}

@freezed
class Timer with _$Timer {
  const factory Timer({
    @JsonKey(name: 'screenIndex') int? screenIndex,
    @JsonKey(name: 'screenCd') String? screenCd,
    @JsonKey(name: 'nextScreenCd') String? nextScreenCd,
    @JsonKey(name: 'value') int? value,
  }) = _Timer;

  factory Timer.fromJson(Map<String, Object?> json) => _$TimerFromJson(json);
}

@freezed
class AppConfigItem with _$AppConfigItem {
  const factory AppConfigItem({
    @JsonKey(name: 'configKey') String? configKey,
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'value') Map<String, Object?>? value,
  }) = _AppConfigItem;

  factory AppConfigItem.fromJson(Map<String, Object?> json) =>
      _$AppConfigItemFromJson(json);
}

@freezed
abstract class FramesInfo with _$FramesInfo {
  const FramesInfo._();

  const factory FramesInfo({
    @JsonKey(name: 'frameCd') String? frameCd,
    @JsonKey(name: 'frameUrl') String? frameUrl,
    @JsonKey(name: 'frameUrlTempDis') String? frameUrlTempDis,
    @JsonKey(name: 'verticalYn') String? verticalYn,
    @JsonKey(name: 'cutYn') String? cutYn,
    @JsonKey(name: 'transparent') String? transparent,
    @JsonKey(name: 'width') String? width,
    @JsonKey(name: 'height') String? height,
    @JsonKey(name: 'printQuantity') String? printQuantity,
    @JsonKey(name: 'price') double? price,
    @JsonKey(name: 'currency') String? currency,
    @JsonKey(name: 'frameSetting') FrameSetting? frameSetting,
    @JsonKey(name: 'backgroundInfo') List<BackgroundInfo>? backgroundInfo,
  }) = _FramesInfo;

  factory FramesInfo.fromJson(Map<String, Object?> json) =>
      _$FramesInfoFromJson(json);

  List<List<double>> getFrameTransparent() {
    final parsed = StringUtils.parseToListOfListDouble(transparent ?? "");
    if (parsed.isEmpty) {
      return [];
    }
    return ListUtils.sortZShape(parsed);
  }

  List<List<double>> getDisplayTransparentAreas({int? fallbackCount}) {
    final parsed = getFrameTransparent();
    if (parsed.isNotEmpty) {
      return parsed;
    }
    final count = fallbackCount ?? (frameSetting?.numOfPhotos ?? 0);
    return _buildFallbackTransparentAreas(count);
  }

  (double, double) getSize() {
    double w = double.tryParse(width ?? "") ?? 1;
    double h = double.tryParse(height ?? "") ?? 1;
    return (w, h);
  }

  (double, double) getInnerImageSize() {
    var transparent = getFrameTransparent();
    if (transparent.isEmpty) {
      return (1, 1);
    }
    double w = transparent.firstOrNull?.elementAtOrNull(2) ?? 1;
    double h = transparent.firstOrNull?.elementAtOrNull(3) ?? 1;
    return (w, h);
  }

  bool isVertical() {
    var innerSize = getInnerImageSize();
    return innerSize.$2 > innerSize.$1;
  }

  bool isVerticalHint() {
    if ((verticalYn ?? "").toUpperCase() == "Y") {
      return true;
    }
    if ((verticalYn ?? "").toUpperCase() == "N") {
      return false;
    }
    final size = getSize();
    return size.$2 >= size.$1;
  }

  bool isCut() {
    return (cutYn ?? "") == "Y";
  }

  List<List<double>> _buildFallbackTransparentAreas(int count) {
    if (count <= 0) {
      return [];
    }

    final vertical = isVerticalHint();
    final cols = vertical ? (count <= 4 ? 1 : 2) : (count <= 3 ? count : 3);
    final rows = (count / cols).ceil();

    const marginX = 0.06;
    const marginY = 0.06;
    const gapX = 0.04;
    const gapY = 0.04;

    final availableWidth = 1 - (marginX * 2) - (gapX * (cols - 1));
    final availableHeight = 1 - (marginY * 2) - (gapY * (rows - 1));
    final cellWidth = availableWidth / cols;
    final cellHeight = availableHeight / rows;
    final size = getSize();

    final areas = <List<double>>[];
    for (int index = 0; index < count; index++) {
      final row = index ~/ cols;
      final col = index % cols;
      areas.add([
        (marginX + (col * (cellWidth + gapX))) * size.$1,
        (marginY + (row * (cellHeight + gapY))) * size.$2,
        cellWidth * size.$1,
        cellHeight * size.$2,
      ]);
    }
    return areas;
  }
}

@freezed
class BackgroundInfo with _$BackgroundInfo {
  const factory BackgroundInfo({
    @JsonKey(name: 'bgCateCd') String? bgCateCd,
    @JsonKey(name: 'bgCateNm') String? bgCateNm,
    @JsonKey(name: 'bgCateIcon') String? bgCateIcon,
    @JsonKey(name: 'background') List<Background>? background,
  }) = _BackgroundInfo;

  factory BackgroundInfo.fromJson(Map<String, Object?> json) =>
      _$BackgroundInfoFromJson(json);
}

@freezed
class Background with _$Background {
  const Background._();

  const factory Background({
    @JsonKey(name: 'bgCd') String? bgCd,
    @JsonKey(name: 'bgNm') String? bgNm,
    @JsonKey(name: 'bgUrl') String? bgUrl,
    @JsonKey(name: 'transparent') List<List<double>>? transparent,
    @JsonKey(name: 'maskJson') List<BackgroundMaskArea>? maskJson,
  }) = _Background;

  factory Background.fromJson(Map<String, Object?> json) =>
      _$BackgroundFromJson(json);

  List<BackgroundMaskArea> getMaskAreas() {
    return maskJson ?? [];
  }

  List<List<double>> getTransparentAreas() {
    return transparent ?? [];
  }
}

@freezed
class BackgroundMaskArea with _$BackgroundMaskArea {
  const BackgroundMaskArea._();

  const factory BackgroundMaskArea({
    @JsonKey(name: 'x') required double x,
    @JsonKey(name: 'y') required double y,
    @JsonKey(name: 'width') required double width,
    @JsonKey(name: 'height') required double height,
    @JsonKey(name: 'type') required String type,
  }) = _BackgroundMaskArea;

  factory BackgroundMaskArea.fromJson(Map<String, Object?> json) =>
      _$BackgroundMaskAreaFromJson(json);

  bool get isTransparent => type.toLowerCase() == 'transparent';
  bool get isWhite => type.toLowerCase() == 'white';
}

@freezed
class FrameSetting with _$FrameSetting {
  const factory FrameSetting({
    @JsonKey(name: 'numOfPhotos') int? numOfPhotos,
    @JsonKey(name: 'shortCount') int? shortCount,
    @JsonKey(name: 'timePerShot') int? timePerShot,
    @JsonKey(name: 'additionPrice') double? additionPrice,
    @JsonKey(name: 'addPhotoNumber') int? addPhotoNumber,
    @JsonKey(name: 'addPhotoLimit') int? addPhotoLimit,
  }) = _FrameSetting;

  factory FrameSetting.fromJson(Map<String, Object?> json) =>
      _$FrameSettingFromJson(json);
}
