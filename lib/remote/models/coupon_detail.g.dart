// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponDetailImpl _$$CouponDetailImplFromJson(Map<String, dynamic> json) =>
    _$CouponDetailImpl(
      code: json['code'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      discountType: json['discountType'] as String?,
      expiryDate: json['expiryDate'] as String?,
      maxUsage: (json['maxUsage'] as num?)?.toInt(),
      usedCount: (json['usedCount'] as num?)?.toInt(),
      couponType: json['couponType'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$$CouponDetailImplToJson(_$CouponDetailImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'discount': instance.discount,
      'discountType': instance.discountType,
      'expiryDate': instance.expiryDate,
      'maxUsage': instance.maxUsage,
      'usedCount': instance.usedCount,
      'couponType': instance.couponType,
      'active': instance.active,
    };
