// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KioskEventResponseImpl _$$KioskEventResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$KioskEventResponseImpl(
      eventId: json['eventId'] as String?,
      eventType: json['eventType'] as String?,
      occurredAt: json['occurredAt'] as String?,
    );

Map<String, dynamic> _$$KioskEventResponseImplToJson(
        _$KioskEventResponseImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventType': instance.eventType,
      'occurredAt': instance.occurredAt,
    };
