// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CouponDetail _$CouponDetailFromJson(Map<String, dynamic> json) {
  return _CouponDetail.fromJson(json);
}

/// @nodoc
mixin _$CouponDetail {
  @JsonKey(name: 'code')
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount')
  double? get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'discountType')
  String? get discountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiryDate')
  String? get expiryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'maxUsage')
  int? get maxUsage => throw _privateConstructorUsedError;
  @JsonKey(name: 'usedCount')
  int? get usedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'couponType')
  String? get couponType => throw _privateConstructorUsedError;
  @JsonKey(name: 'active')
  bool? get active => throw _privateConstructorUsedError;

  /// Serializes this CouponDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponDetailCopyWith<CouponDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponDetailCopyWith<$Res> {
  factory $CouponDetailCopyWith(
          CouponDetail value, $Res Function(CouponDetail) then) =
      _$CouponDetailCopyWithImpl<$Res, CouponDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'discount') double? discount,
      @JsonKey(name: 'discountType') String? discountType,
      @JsonKey(name: 'expiryDate') String? expiryDate,
      @JsonKey(name: 'maxUsage') int? maxUsage,
      @JsonKey(name: 'usedCount') int? usedCount,
      @JsonKey(name: 'couponType') String? couponType,
      @JsonKey(name: 'active') bool? active});
}

/// @nodoc
class _$CouponDetailCopyWithImpl<$Res, $Val extends CouponDetail>
    implements $CouponDetailCopyWith<$Res> {
  _$CouponDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CouponDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? discount = freezed,
    Object? discountType = freezed,
    Object? expiryDate = freezed,
    Object? maxUsage = freezed,
    Object? usedCount = freezed,
    Object? couponType = freezed,
    Object? active = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double?,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      maxUsage: freezed == maxUsage
          ? _value.maxUsage
          : maxUsage // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: freezed == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      couponType: freezed == couponType
          ? _value.couponType
          : couponType // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CouponDetailImplCopyWith<$Res>
    implements $CouponDetailCopyWith<$Res> {
  factory _$$CouponDetailImplCopyWith(
          _$CouponDetailImpl value, $Res Function(_$CouponDetailImpl) then) =
      __$$CouponDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'discount') double? discount,
      @JsonKey(name: 'discountType') String? discountType,
      @JsonKey(name: 'expiryDate') String? expiryDate,
      @JsonKey(name: 'maxUsage') int? maxUsage,
      @JsonKey(name: 'usedCount') int? usedCount,
      @JsonKey(name: 'couponType') String? couponType,
      @JsonKey(name: 'active') bool? active});
}

/// @nodoc
class __$$CouponDetailImplCopyWithImpl<$Res>
    extends _$CouponDetailCopyWithImpl<$Res, _$CouponDetailImpl>
    implements _$$CouponDetailImplCopyWith<$Res> {
  __$$CouponDetailImplCopyWithImpl(
      _$CouponDetailImpl _value, $Res Function(_$CouponDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of CouponDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? discount = freezed,
    Object? discountType = freezed,
    Object? expiryDate = freezed,
    Object? maxUsage = freezed,
    Object? usedCount = freezed,
    Object? couponType = freezed,
    Object? active = freezed,
  }) {
    return _then(_$CouponDetailImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double?,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      maxUsage: freezed == maxUsage
          ? _value.maxUsage
          : maxUsage // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: freezed == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      couponType: freezed == couponType
          ? _value.couponType
          : couponType // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponDetailImpl implements _CouponDetail {
  const _$CouponDetailImpl(
      {@JsonKey(name: 'code') this.code,
      @JsonKey(name: 'discount') this.discount,
      @JsonKey(name: 'discountType') this.discountType,
      @JsonKey(name: 'expiryDate') this.expiryDate,
      @JsonKey(name: 'maxUsage') this.maxUsage,
      @JsonKey(name: 'usedCount') this.usedCount,
      @JsonKey(name: 'couponType') this.couponType,
      @JsonKey(name: 'active') this.active});

  factory _$CouponDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponDetailImplFromJson(json);

  @override
  @JsonKey(name: 'code')
  final String? code;
  @override
  @JsonKey(name: 'discount')
  final double? discount;
  @override
  @JsonKey(name: 'discountType')
  final String? discountType;
  @override
  @JsonKey(name: 'expiryDate')
  final String? expiryDate;
  @override
  @JsonKey(name: 'maxUsage')
  final int? maxUsage;
  @override
  @JsonKey(name: 'usedCount')
  final int? usedCount;
  @override
  @JsonKey(name: 'couponType')
  final String? couponType;
  @override
  @JsonKey(name: 'active')
  final bool? active;

  @override
  String toString() {
    return 'CouponDetail(code: $code, discount: $discount, discountType: $discountType, expiryDate: $expiryDate, maxUsage: $maxUsage, usedCount: $usedCount, couponType: $couponType, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponDetailImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.maxUsage, maxUsage) ||
                other.maxUsage == maxUsage) &&
            (identical(other.usedCount, usedCount) ||
                other.usedCount == usedCount) &&
            (identical(other.couponType, couponType) ||
                other.couponType == couponType) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, discount, discountType,
      expiryDate, maxUsage, usedCount, couponType, active);

  /// Create a copy of CouponDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponDetailImplCopyWith<_$CouponDetailImpl> get copyWith =>
      __$$CouponDetailImplCopyWithImpl<_$CouponDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponDetailImplToJson(
      this,
    );
  }
}

abstract class _CouponDetail implements CouponDetail {
  const factory _CouponDetail(
      {@JsonKey(name: 'code') final String? code,
      @JsonKey(name: 'discount') final double? discount,
      @JsonKey(name: 'discountType') final String? discountType,
      @JsonKey(name: 'expiryDate') final String? expiryDate,
      @JsonKey(name: 'maxUsage') final int? maxUsage,
      @JsonKey(name: 'usedCount') final int? usedCount,
      @JsonKey(name: 'couponType') final String? couponType,
      @JsonKey(name: 'active') final bool? active}) = _$CouponDetailImpl;

  factory _CouponDetail.fromJson(Map<String, dynamic> json) =
      _$CouponDetailImpl.fromJson;

  @override
  @JsonKey(name: 'code')
  String? get code;
  @override
  @JsonKey(name: 'discount')
  double? get discount;
  @override
  @JsonKey(name: 'discountType')
  String? get discountType;
  @override
  @JsonKey(name: 'expiryDate')
  String? get expiryDate;
  @override
  @JsonKey(name: 'maxUsage')
  int? get maxUsage;
  @override
  @JsonKey(name: 'usedCount')
  int? get usedCount;
  @override
  @JsonKey(name: 'couponType')
  String? get couponType;
  @override
  @JsonKey(name: 'active')
  bool? get active;

  /// Create a copy of CouponDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponDetailImplCopyWith<_$CouponDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
