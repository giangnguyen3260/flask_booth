import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_l/common/models/effect.dart';

part 'preset.freezed.dart';
part 'preset.g.dart';

@freezed
class Preset with _$Preset {
  const Preset._();

  const factory Preset({
    @JsonKey(name: 'filterName')@Default("") String presetName,
    required Effect value, // Changed from List<Effect> to a single Effect
  }) = _Preset;

  factory Preset.fromJson(Map<String, dynamic> json) => _$PresetFromJson(json);
}

@freezed
class PresetCategory with _$PresetCategory {
  const factory PresetCategory({
    @JsonKey(name: 'categoryName') @Default("") String name, // Match JSON key
    @JsonKey(name: 'filters') @Default([]) List<Preset> presets, // Match JSON key
  }) = _PresetCategory;

  factory PresetCategory.fromJson(Map<String, dynamic> json) => _$PresetCategoryFromJson(json);
}