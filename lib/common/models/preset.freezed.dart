// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Preset _$PresetFromJson(Map<String, dynamic> json) {
  return _Preset.fromJson(json);
}

/// @nodoc
mixin _$Preset {
  @JsonKey(name: 'filterName')
  String get presetName => throw _privateConstructorUsedError;
  Effect get value => throw _privateConstructorUsedError;

  /// Serializes this Preset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetCopyWith<Preset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetCopyWith<$Res> {
  factory $PresetCopyWith(Preset value, $Res Function(Preset) then) =
      _$PresetCopyWithImpl<$Res, Preset>;
  @useResult
  $Res call({@JsonKey(name: 'filterName') String presetName, Effect value});

  $EffectCopyWith<$Res> get value;
}

/// @nodoc
class _$PresetCopyWithImpl<$Res, $Val extends Preset>
    implements $PresetCopyWith<$Res> {
  _$PresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presetName = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      presetName: null == presetName
          ? _value.presetName
          : presetName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Effect,
    ) as $Val);
  }

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EffectCopyWith<$Res> get value {
    return $EffectCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PresetImplCopyWith<$Res> implements $PresetCopyWith<$Res> {
  factory _$$PresetImplCopyWith(
          _$PresetImpl value, $Res Function(_$PresetImpl) then) =
      __$$PresetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'filterName') String presetName, Effect value});

  @override
  $EffectCopyWith<$Res> get value;
}

/// @nodoc
class __$$PresetImplCopyWithImpl<$Res>
    extends _$PresetCopyWithImpl<$Res, _$PresetImpl>
    implements _$$PresetImplCopyWith<$Res> {
  __$$PresetImplCopyWithImpl(
      _$PresetImpl _value, $Res Function(_$PresetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presetName = null,
    Object? value = null,
  }) {
    return _then(_$PresetImpl(
      presetName: null == presetName
          ? _value.presetName
          : presetName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Effect,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PresetImpl extends _Preset {
  const _$PresetImpl(
      {@JsonKey(name: 'filterName') this.presetName = "", required this.value})
      : super._();

  factory _$PresetImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresetImplFromJson(json);

  @override
  @JsonKey(name: 'filterName')
  final String presetName;
  @override
  final Effect value;

  @override
  String toString() {
    return 'Preset(presetName: $presetName, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetImpl &&
            (identical(other.presetName, presetName) ||
                other.presetName == presetName) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, presetName, value);

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetImplCopyWith<_$PresetImpl> get copyWith =>
      __$$PresetImplCopyWithImpl<_$PresetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresetImplToJson(
      this,
    );
  }
}

abstract class _Preset extends Preset {
  const factory _Preset(
      {@JsonKey(name: 'filterName') final String presetName,
      required final Effect value}) = _$PresetImpl;
  const _Preset._() : super._();

  factory _Preset.fromJson(Map<String, dynamic> json) = _$PresetImpl.fromJson;

  @override
  @JsonKey(name: 'filterName')
  String get presetName;
  @override
  Effect get value;

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetImplCopyWith<_$PresetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PresetCategory _$PresetCategoryFromJson(Map<String, dynamic> json) {
  return _PresetCategory.fromJson(json);
}

/// @nodoc
mixin _$PresetCategory {
  @JsonKey(name: 'categoryName')
  String get name => throw _privateConstructorUsedError; // Match JSON key
  @JsonKey(name: 'filters')
  List<Preset> get presets => throw _privateConstructorUsedError;

  /// Serializes this PresetCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PresetCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetCategoryCopyWith<PresetCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetCategoryCopyWith<$Res> {
  factory $PresetCategoryCopyWith(
          PresetCategory value, $Res Function(PresetCategory) then) =
      _$PresetCategoryCopyWithImpl<$Res, PresetCategory>;
  @useResult
  $Res call(
      {@JsonKey(name: 'categoryName') String name,
      @JsonKey(name: 'filters') List<Preset> presets});
}

/// @nodoc
class _$PresetCategoryCopyWithImpl<$Res, $Val extends PresetCategory>
    implements $PresetCategoryCopyWith<$Res> {
  _$PresetCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresetCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? presets = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      presets: null == presets
          ? _value.presets
          : presets // ignore: cast_nullable_to_non_nullable
              as List<Preset>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PresetCategoryImplCopyWith<$Res>
    implements $PresetCategoryCopyWith<$Res> {
  factory _$$PresetCategoryImplCopyWith(_$PresetCategoryImpl value,
          $Res Function(_$PresetCategoryImpl) then) =
      __$$PresetCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'categoryName') String name,
      @JsonKey(name: 'filters') List<Preset> presets});
}

/// @nodoc
class __$$PresetCategoryImplCopyWithImpl<$Res>
    extends _$PresetCategoryCopyWithImpl<$Res, _$PresetCategoryImpl>
    implements _$$PresetCategoryImplCopyWith<$Res> {
  __$$PresetCategoryImplCopyWithImpl(
      _$PresetCategoryImpl _value, $Res Function(_$PresetCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of PresetCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? presets = null,
  }) {
    return _then(_$PresetCategoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      presets: null == presets
          ? _value._presets
          : presets // ignore: cast_nullable_to_non_nullable
              as List<Preset>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PresetCategoryImpl implements _PresetCategory {
  const _$PresetCategoryImpl(
      {@JsonKey(name: 'categoryName') this.name = "",
      @JsonKey(name: 'filters') final List<Preset> presets = const []})
      : _presets = presets;

  factory _$PresetCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresetCategoryImplFromJson(json);

  @override
  @JsonKey(name: 'categoryName')
  final String name;
// Match JSON key
  final List<Preset> _presets;
// Match JSON key
  @override
  @JsonKey(name: 'filters')
  List<Preset> get presets {
    if (_presets is EqualUnmodifiableListView) return _presets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_presets);
  }

  @override
  String toString() {
    return 'PresetCategory(name: $name, presets: $presets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._presets, _presets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_presets));

  /// Create a copy of PresetCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetCategoryImplCopyWith<_$PresetCategoryImpl> get copyWith =>
      __$$PresetCategoryImplCopyWithImpl<_$PresetCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresetCategoryImplToJson(
      this,
    );
  }
}

abstract class _PresetCategory implements PresetCategory {
  const factory _PresetCategory(
          {@JsonKey(name: 'categoryName') final String name,
          @JsonKey(name: 'filters') final List<Preset> presets}) =
      _$PresetCategoryImpl;

  factory _PresetCategory.fromJson(Map<String, dynamic> json) =
      _$PresetCategoryImpl.fromJson;

  @override
  @JsonKey(name: 'categoryName')
  String get name; // Match JSON key
  @override
  @JsonKey(name: 'filters')
  List<Preset> get presets;

  /// Create a copy of PresetCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetCategoryImplCopyWith<_$PresetCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
