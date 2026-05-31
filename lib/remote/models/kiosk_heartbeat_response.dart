import 'package:freezed_annotation/freezed_annotation.dart';

part 'kiosk_heartbeat_response.freezed.dart';
part 'kiosk_heartbeat_response.g.dart';

@freezed
class KioskHeartbeatResponse with _$KioskHeartbeatResponse {
  const factory KioskHeartbeatResponse({
    @JsonKey(name: 'kioskCode') String? kioskCode,
    @JsonKey(name: 'active') bool? active,
    @JsonKey(name: 'maintenanceMode') bool? maintenanceMode,
    @JsonKey(name: 'currentScreen') String? currentScreen,
    @JsonKey(name: 'currentSessionId') String? currentSessionId,
    @JsonKey(name: 'lastSeenAt') String? lastSeenAt,
    @JsonKey(name: 'pendingCommands') int? pendingCommands,
    @JsonKey(name: 'serverTime') String? serverTime,
  }) = _KioskHeartbeatResponse;

  factory KioskHeartbeatResponse.fromJson(Map<String, Object?> json) =>
      _$KioskHeartbeatResponseFromJson(json);
}
