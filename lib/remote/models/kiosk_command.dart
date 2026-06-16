import 'package:freezed_annotation/freezed_annotation.dart';

part 'kiosk_command.freezed.dart';
part 'kiosk_command.g.dart';

@freezed
class KioskCommand with _$KioskCommand {
  const factory KioskCommand({
    @JsonKey(name: 'commandId') String? commandId,
    @JsonKey(name: 'commandType') String? commandType,
    @JsonKey(name: 'payload') KioskCommandPayload? payload,
  }) = _KioskCommand;

  factory KioskCommand.fromJson(Map<String, Object?> json) =>
      _$KioskCommandFromJson(json);
}

@freezed
class KioskCommandPayload with _$KioskCommandPayload {
  const factory KioskCommandPayload({
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'printQuantity') int? printQuantity,
    @JsonKey(name: 'isCut') bool? isCut,
    @JsonKey(name: 'orientation') String? orientation,
  }) = _KioskCommandPayload;

  factory KioskCommandPayload.fromJson(Map<String, Object?> json) =>
      _$KioskCommandPayloadFromJson(json);
}
