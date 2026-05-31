import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_detail.freezed.dart';
part 'coupon_detail.g.dart';

@freezed
class CouponDetail with _$CouponDetail {
  const factory CouponDetail({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'discount') double? discount,
    @JsonKey(name: 'discountType') String? discountType,
    @JsonKey(name: 'expiryDate') String? expiryDate,
    @JsonKey(name: 'maxUsage') int? maxUsage,
    @JsonKey(name: 'usedCount') int? usedCount,
    @JsonKey(name: 'couponType') String? couponType,
    @JsonKey(name: 'active') bool? active,
  }) = _CouponDetail;

  factory CouponDetail.fromJson(Map<String, Object?> json) => _$CouponDetailFromJson(json);
}


extension CouponDetailX on CouponDetail {
  bool get isEmpty {
    return code == null || discount == null || discountType == null;
  }
}
