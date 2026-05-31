// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QRDetail _$QRDetailFromJson(Map<String, dynamic> json) {
  return _QRDetail.fromJson(json);
}

/// @nodoc
mixin _$QRDetail {
  @JsonKey(name: 'qrUrl')
  String? get qrUrl => throw _privateConstructorUsedError;

  /// Serializes this QRDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QRDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QRDetailCopyWith<QRDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QRDetailCopyWith<$Res> {
  factory $QRDetailCopyWith(QRDetail value, $Res Function(QRDetail) then) =
      _$QRDetailCopyWithImpl<$Res, QRDetail>;
  @useResult
  $Res call({@JsonKey(name: 'qrUrl') String? qrUrl});
}

/// @nodoc
class _$QRDetailCopyWithImpl<$Res, $Val extends QRDetail>
    implements $QRDetailCopyWith<$Res> {
  _$QRDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QRDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrUrl = freezed,
  }) {
    return _then(_value.copyWith(
      qrUrl: freezed == qrUrl
          ? _value.qrUrl
          : qrUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QRDetailImplCopyWith<$Res>
    implements $QRDetailCopyWith<$Res> {
  factory _$$QRDetailImplCopyWith(
          _$QRDetailImpl value, $Res Function(_$QRDetailImpl) then) =
      __$$QRDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'qrUrl') String? qrUrl});
}

/// @nodoc
class __$$QRDetailImplCopyWithImpl<$Res>
    extends _$QRDetailCopyWithImpl<$Res, _$QRDetailImpl>
    implements _$$QRDetailImplCopyWith<$Res> {
  __$$QRDetailImplCopyWithImpl(
      _$QRDetailImpl _value, $Res Function(_$QRDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of QRDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrUrl = freezed,
  }) {
    return _then(_$QRDetailImpl(
      qrUrl: freezed == qrUrl
          ? _value.qrUrl
          : qrUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QRDetailImpl implements _QRDetail {
  const _$QRDetailImpl({@JsonKey(name: 'qrUrl') this.qrUrl});

  factory _$QRDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$QRDetailImplFromJson(json);

  @override
  @JsonKey(name: 'qrUrl')
  final String? qrUrl;

  @override
  String toString() {
    return 'QRDetail(qrUrl: $qrUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QRDetailImpl &&
            (identical(other.qrUrl, qrUrl) || other.qrUrl == qrUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, qrUrl);

  /// Create a copy of QRDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QRDetailImplCopyWith<_$QRDetailImpl> get copyWith =>
      __$$QRDetailImplCopyWithImpl<_$QRDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QRDetailImplToJson(
      this,
    );
  }
}

abstract class _QRDetail implements QRDetail {
  const factory _QRDetail({@JsonKey(name: 'qrUrl') final String? qrUrl}) =
      _$QRDetailImpl;

  factory _QRDetail.fromJson(Map<String, dynamic> json) =
      _$QRDetailImpl.fromJson;

  @override
  @JsonKey(name: 'qrUrl')
  String? get qrUrl;

  /// Create a copy of QRDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QRDetailImplCopyWith<_$QRDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
