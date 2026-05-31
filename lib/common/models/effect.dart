import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_l/common/enums/filter_enum.dart';

part 'effect.freezed.dart';
part 'effect.g.dart';

@Freezed()
abstract class Effect with _$Effect {
  const Effect._();

  const factory Effect({
    @Default(0.0) double brightness,
    @Default(1.0) double contrast,
    @Default(1.0) double saturation,
    @Default(0.0) double vibrance,
    @Default(0.0) double temperature,
    @Default(0.0) double sepia,
    @Default(0.0) double grain,
  }) = _Effect;

  factory Effect.fromJson(Map<String, dynamic> json) => _$EffectFromJson(json);


  double getValueFromFilter(FilterEnum filter) {
    return switch (filter) {
      FilterEnum.brightness => brightness,
      FilterEnum.contrast => contrast,
      FilterEnum.saturation => saturation,
      FilterEnum.vibrance => vibrance,
      FilterEnum.temperature => temperature,
      FilterEnum.sepia => sepia,
      FilterEnum.grain => grain,
    };
  }

  static List<Effect> fromListEnumMap(List<Map<FilterEnum, double>> list) {
    List<Effect> tList = [];
    for (var e in list) {
      tList.add(fromEnumMap(e));
    }
    return tList;
  }

  static Effect fromEnumMap(Map<FilterEnum, double> map) {
    return Effect(
      brightness: map[FilterEnum.brightness] ?? 0.0,
      contrast: map[FilterEnum.contrast] ?? 1.0,
      saturation: map[FilterEnum.saturation] ?? 1.0,
      vibrance: map[FilterEnum.vibrance] ?? 0.0,
      temperature: map[FilterEnum.temperature] ?? 0.0,
      sepia: map[FilterEnum.sepia] ?? 0.0,
      grain: map[FilterEnum.grain] ?? 0.0,
    );
  }

  Map<FilterEnum, double> getMap() {
    return {
      FilterEnum.brightness: brightness,
      FilterEnum.contrast: contrast,
      FilterEnum.saturation: saturation,
      FilterEnum.vibrance: vibrance,
      FilterEnum.temperature: temperature,
      FilterEnum.sepia: sepia,
      FilterEnum.grain: grain,
    };
  }
}
