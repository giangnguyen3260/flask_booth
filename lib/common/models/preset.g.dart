// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PresetImpl _$$PresetImplFromJson(Map<String, dynamic> json) => _$PresetImpl(
      presetName: json['filterName'] as String? ?? "",
      value: Effect.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PresetImplToJson(_$PresetImpl instance) =>
    <String, dynamic>{
      'filterName': instance.presetName,
      'value': instance.value,
    };

_$PresetCategoryImpl _$$PresetCategoryImplFromJson(Map<String, dynamic> json) =>
    _$PresetCategoryImpl(
      name: json['categoryName'] as String? ?? "",
      presets: (json['filters'] as List<dynamic>?)
              ?.map((e) => Preset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PresetCategoryImplToJson(
        _$PresetCategoryImpl instance) =>
    <String, dynamic>{
      'categoryName': instance.name,
      'filters': instance.presets,
    };
