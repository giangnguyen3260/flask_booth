import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_detail.freezed.dart';

part 'qr_detail.g.dart';

@freezed
class QRDetail with _$QRDetail {
  const factory QRDetail({
    @JsonKey(name: 'qrUrl') String? qrUrl,
  }) = _QRDetail;

  factory QRDetail.fromJson(Map<String, Object?> json) =>
      _$QRDetailFromJson(json);
}
