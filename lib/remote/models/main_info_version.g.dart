// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_info_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MainInfoVersionImpl _$$MainInfoVersionImplFromJson(
        Map<String, dynamic> json) =>
    _$MainInfoVersionImpl(
      version: (json['version'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$MainInfoVersionImplToJson(
        _$MainInfoVersionImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'updatedAt': instance.updatedAt,
    };
