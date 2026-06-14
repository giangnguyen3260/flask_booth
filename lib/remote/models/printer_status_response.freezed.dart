// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer_status_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrinterStatusResponse _$PrinterStatusResponseFromJson(
    Map<String, dynamic> json) {
  return _PrinterStatusResponse.fromJson(json);
}

/// @nodoc
mixin _$PrinterStatusResponse {
  @JsonKey(name: 'updated')
  int? get updated => throw _privateConstructorUsedError;

  /// Serializes this PrinterStatusResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterStatusResponseCopyWith<PrinterStatusResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterStatusResponseCopyWith<$Res> {
  factory $PrinterStatusResponseCopyWith(PrinterStatusResponse value,
          $Res Function(PrinterStatusResponse) then) =
      _$PrinterStatusResponseCopyWithImpl<$Res, PrinterStatusResponse>;
  @useResult
  $Res call({@JsonKey(name: 'updated') int? updated});
}

/// @nodoc
class _$PrinterStatusResponseCopyWithImpl<$Res,
        $Val extends PrinterStatusResponse>
    implements $PrinterStatusResponseCopyWith<$Res> {
  _$PrinterStatusResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? updated = freezed,
  }) {
    return _then(_value.copyWith(
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrinterStatusResponseImplCopyWith<$Res>
    implements $PrinterStatusResponseCopyWith<$Res> {
  factory _$$PrinterStatusResponseImplCopyWith(
          _$PrinterStatusResponseImpl value,
          $Res Function(_$PrinterStatusResponseImpl) then) =
      __$$PrinterStatusResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'updated') int? updated});
}

/// @nodoc
class __$$PrinterStatusResponseImplCopyWithImpl<$Res>
    extends _$PrinterStatusResponseCopyWithImpl<$Res,
        _$PrinterStatusResponseImpl>
    implements _$$PrinterStatusResponseImplCopyWith<$Res> {
  __$$PrinterStatusResponseImplCopyWithImpl(_$PrinterStatusResponseImpl _value,
      $Res Function(_$PrinterStatusResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? updated = freezed,
  }) {
    return _then(_$PrinterStatusResponseImpl(
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterStatusResponseImpl implements _PrinterStatusResponse {
  const _$PrinterStatusResponseImpl({@JsonKey(name: 'updated') this.updated});

  factory _$PrinterStatusResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterStatusResponseImplFromJson(json);

  @override
  @JsonKey(name: 'updated')
  final int? updated;

  @override
  String toString() {
    return 'PrinterStatusResponse(updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterStatusResponseImpl &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, updated);

  /// Create a copy of PrinterStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterStatusResponseImplCopyWith<_$PrinterStatusResponseImpl>
      get copyWith => __$$PrinterStatusResponseImplCopyWithImpl<
          _$PrinterStatusResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterStatusResponseImplToJson(
      this,
    );
  }
}

abstract class _PrinterStatusResponse implements PrinterStatusResponse {
  const factory _PrinterStatusResponse(
          {@JsonKey(name: 'updated') final int? updated}) =
      _$PrinterStatusResponseImpl;

  factory _PrinterStatusResponse.fromJson(Map<String, dynamic> json) =
      _$PrinterStatusResponseImpl.fromJson;

  @override
  @JsonKey(name: 'updated')
  int? get updated;

  /// Create a copy of PrinterStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterStatusResponseImplCopyWith<_$PrinterStatusResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
