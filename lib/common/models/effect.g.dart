// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'effect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EffectImpl _$$EffectImplFromJson(Map<String, dynamic> json) => _$EffectImpl(
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0.0,
      contrast: (json['contrast'] as num?)?.toDouble() ?? 1.0,
      saturation: (json['saturation'] as num?)?.toDouble() ?? 1.0,
      vibrance: (json['vibrance'] as num?)?.toDouble() ?? 0.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      sepia: (json['sepia'] as num?)?.toDouble() ?? 0.0,
      grain: (json['grain'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$EffectImplToJson(_$EffectImpl instance) =>
    <String, dynamic>{
      'brightness': instance.brightness,
      'contrast': instance.contrast,
      'saturation': instance.saturation,
      'vibrance': instance.vibrance,
      'temperature': instance.temperature,
      'sepia': instance.sepia,
      'grain': instance.grain,
    };
