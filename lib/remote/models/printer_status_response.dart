import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_status_response.freezed.dart';
part 'printer_status_response.g.dart';

@freezed
class PrinterStatusResponse with _$PrinterStatusResponse {
  const factory PrinterStatusResponse({
    @JsonKey(name: 'updated') int? updated,
  }) = _PrinterStatusResponse;

  factory PrinterStatusResponse.fromJson(Map<String, Object?> json) =>
      _$PrinterStatusResponseFromJson(json);
}
