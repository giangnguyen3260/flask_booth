// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KioskCommandImpl _$$KioskCommandImplFromJson(Map<String, dynamic> json) =>
    _$KioskCommandImpl(
      commandId: json['commandId'] as String?,
      commandType: json['commandType'] as String?,
      payload: json['payload'] == null
          ? null
          : KioskCommandPayload.fromJson(
              json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$KioskCommandImplToJson(_$KioskCommandImpl instance) =>
    <String, dynamic>{
      'commandId': instance.commandId,
      'commandType': instance.commandType,
      'payload': instance.payload,
    };

_$KioskCommandPayloadImpl _$$KioskCommandPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$KioskCommandPayloadImpl(
      imageUrl: json['imageUrl'] as String?,
      printQuantity: (json['printQuantity'] as num?)?.toInt(),
      isCut: json['isCut'] as bool?,
      orientation: json['orientation'] as String?,
    );

Map<String, dynamic> _$$KioskCommandPayloadImplToJson(
        _$KioskCommandPayloadImpl instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'printQuantity': instance.printQuantity,
      'isCut': instance.isCut,
      'orientation': instance.orientation,
    };
