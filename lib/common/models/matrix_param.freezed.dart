// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matrix_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MatrixParam {
  double get scale => throw _privateConstructorUsedError;
  double get panX => throw _privateConstructorUsedError;
  double get panY => throw _privateConstructorUsedError;

  /// Create a copy of MatrixParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatrixParamCopyWith<MatrixParam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatrixParamCopyWith<$Res> {
  factory $MatrixParamCopyWith(
          MatrixParam value, $Res Function(MatrixParam) then) =
      _$MatrixParamCopyWithImpl<$Res, MatrixParam>;
  @useResult
  $Res call({double scale, double panX, double panY});
}

/// @nodoc
class _$MatrixParamCopyWithImpl<$Res, $Val extends MatrixParam>
    implements $MatrixParamCopyWith<$Res> {
  _$MatrixParamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatrixParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scale = null,
    Object? panX = null,
    Object? panY = null,
  }) {
    return _then(_value.copyWith(
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      panX: null == panX
          ? _value.panX
          : panX // ignore: cast_nullable_to_non_nullable
              as double,
      panY: null == panY
          ? _value.panY
          : panY // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatrixParamImplCopyWith<$Res>
    implements $MatrixParamCopyWith<$Res> {
  factory _$$MatrixParamImplCopyWith(
          _$MatrixParamImpl value, $Res Function(_$MatrixParamImpl) then) =
      __$$MatrixParamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double scale, double panX, double panY});
}

/// @nodoc
class __$$MatrixParamImplCopyWithImpl<$Res>
    extends _$MatrixParamCopyWithImpl<$Res, _$MatrixParamImpl>
    implements _$$MatrixParamImplCopyWith<$Res> {
  __$$MatrixParamImplCopyWithImpl(
      _$MatrixParamImpl _value, $Res Function(_$MatrixParamImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scale = null,
    Object? panX = null,
    Object? panY = null,
  }) {
    return _then(_$MatrixParamImpl(
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      panX: null == panX
          ? _value.panX
          : panX // ignore: cast_nullable_to_non_nullable
              as double,
      panY: null == panY
          ? _value.panY
          : panY // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$MatrixParamImpl implements _MatrixParam {
  const _$MatrixParamImpl({this.scale = 1.0, this.panX = 0.0, this.panY = 0.0});

  @override
  @JsonKey()
  final double scale;
  @override
  @JsonKey()
  final double panX;
  @override
  @JsonKey()
  final double panY;

  @override
  String toString() {
    return 'MatrixParam(scale: $scale, panX: $panX, panY: $panY)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatrixParamImpl &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.panX, panX) || other.panX == panX) &&
            (identical(other.panY, panY) || other.panY == panY));
  }

  @override
  int get hashCode => Object.hash(runtimeType, scale, panX, panY);

  /// Create a copy of MatrixParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatrixParamImplCopyWith<_$MatrixParamImpl> get copyWith =>
      __$$MatrixParamImplCopyWithImpl<_$MatrixParamImpl>(this, _$identity);
}

abstract class _MatrixParam implements MatrixParam {
  const factory _MatrixParam(
      {final double scale,
      final double panX,
      final double panY}) = _$MatrixParamImpl;

  @override
  double get scale;
  @override
  double get panX;
  @override
  double get panY;

  /// Create a copy of MatrixParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatrixParamImplCopyWith<_$MatrixParamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
