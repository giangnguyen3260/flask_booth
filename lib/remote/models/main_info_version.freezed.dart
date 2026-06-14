// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_info_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MainInfoVersion _$MainInfoVersionFromJson(Map<String, dynamic> json) {
  return _MainInfoVersion.fromJson(json);
}

/// @nodoc
mixin _$MainInfoVersion {
  @JsonKey(name: 'version')
  int? get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MainInfoVersion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MainInfoVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MainInfoVersionCopyWith<MainInfoVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainInfoVersionCopyWith<$Res> {
  factory $MainInfoVersionCopyWith(
          MainInfoVersion value, $Res Function(MainInfoVersion) then) =
      _$MainInfoVersionCopyWithImpl<$Res, MainInfoVersion>;
  @useResult
  $Res call(
      {@JsonKey(name: 'version') int? version,
      @JsonKey(name: 'updatedAt') String? updatedAt});
}

/// @nodoc
class _$MainInfoVersionCopyWithImpl<$Res, $Val extends MainInfoVersion>
    implements $MainInfoVersionCopyWith<$Res> {
  _$MainInfoVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainInfoVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MainInfoVersionImplCopyWith<$Res>
    implements $MainInfoVersionCopyWith<$Res> {
  factory _$$MainInfoVersionImplCopyWith(_$MainInfoVersionImpl value,
          $Res Function(_$MainInfoVersionImpl) then) =
      __$$MainInfoVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'version') int? version,
      @JsonKey(name: 'updatedAt') String? updatedAt});
}

/// @nodoc
class __$$MainInfoVersionImplCopyWithImpl<$Res>
    extends _$MainInfoVersionCopyWithImpl<$Res, _$MainInfoVersionImpl>
    implements _$$MainInfoVersionImplCopyWith<$Res> {
  __$$MainInfoVersionImplCopyWithImpl(
      _$MainInfoVersionImpl _value, $Res Function(_$MainInfoVersionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainInfoVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MainInfoVersionImpl(
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MainInfoVersionImpl implements _MainInfoVersion {
  const _$MainInfoVersionImpl(
      {@JsonKey(name: 'version') this.version,
      @JsonKey(name: 'updatedAt') this.updatedAt});

  factory _$MainInfoVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MainInfoVersionImplFromJson(json);

  @override
  @JsonKey(name: 'version')
  final int? version;
  @override
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  @override
  String toString() {
    return 'MainInfoVersion(version: $version, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainInfoVersionImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, updatedAt);

  /// Create a copy of MainInfoVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MainInfoVersionImplCopyWith<_$MainInfoVersionImpl> get copyWith =>
      __$$MainInfoVersionImplCopyWithImpl<_$MainInfoVersionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MainInfoVersionImplToJson(
      this,
    );
  }
}

abstract class _MainInfoVersion implements MainInfoVersion {
  const factory _MainInfoVersion(
          {@JsonKey(name: 'version') final int? version,
          @JsonKey(name: 'updatedAt') final String? updatedAt}) =
      _$MainInfoVersionImpl;

  factory _MainInfoVersion.fromJson(Map<String, dynamic> json) =
      _$MainInfoVersionImpl.fromJson;

  @override
  @JsonKey(name: 'version')
  int? get version;
  @override
  @JsonKey(name: 'updatedAt')
  String? get updatedAt;

  /// Create a copy of MainInfoVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MainInfoVersionImplCopyWith<_$MainInfoVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
