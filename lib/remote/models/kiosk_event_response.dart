import 'package:freezed_annotation/freezed_annotation.dart';

part 'kiosk_event_response.freezed.dart';
part 'kiosk_event_response.g.dart';

@freezed
class KioskEventResponse with _$KioskEventResponse {
  const factory KioskEventResponse({
    @JsonKey(name: 'eventId') String? eventId,
    @JsonKey(name: 'eventType') String? eventType,
    @JsonKey(name: 'occurredAt') String? occurredAt,
  }) = _KioskEventResponse;

  factory KioskEventResponse.fromJson(Map<String, Object?> json) =>
      _$KioskEventResponseFromJson(json);
}
