// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_heartbeat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KioskHeartbeatResponseImpl _$$KioskHeartbeatResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$KioskHeartbeatResponseImpl(
      kioskCode: json['kioskCode'] as String?,
      active: json['active'] as bool?,
      maintenanceMode: json['maintenanceMode'] as bool?,
      currentScreen: json['currentScreen'] as String?,
      currentSessionId: json['currentSessionId'] as String?,
      lastSeenAt: json['lastSeenAt'] as String?,
      pendingCommands: (json['pendingCommands'] as num?)?.toInt(),
      serverTime: json['serverTime'] as String?,
    );

Map<String, dynamic> _$$KioskHeartbeatResponseImplToJson(
        _$KioskHeartbeatResponseImpl instance) =>
    <String, dynamic>{
      'kioskCode': instance.kioskCode,
      'active': instance.active,
      'maintenanceMode': instance.maintenanceMode,
      'currentScreen': instance.currentScreen,
      'currentSessionId': instance.currentSessionId,
      'lastSeenAt': instance.lastSeenAt,
      'pendingCommands': instance.pendingCommands,
      'serverTime': instance.serverTime,
    };
