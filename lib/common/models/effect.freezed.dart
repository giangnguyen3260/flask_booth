// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'effect.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Effect _$EffectFromJson(Map<String, dynamic> json) {
  return _Effect.fromJson(json);
}

/// @nodoc
mixin _$Effect {
  double get brightness => throw _privateConstructorUsedError;
  double get contrast => throw _privateConstructorUsedError;
  double get saturation => throw _privateConstructorUsedError;
  double get vibrance => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  double get sepia => throw _privateConstructorUsedError;
  double get grain => throw _privateConstructorUsedError;

  /// Serializes this Effect to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Effect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EffectCopyWith<Effect> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EffectCopyWith<$Res> {
  factory $EffectCopyWith(Effect value, $Res Function(Effect) then) =
      _$EffectCopyWithImpl<$Res, Effect>;
  @useResult
  $Res call(
      {double brightness,
      double contrast,
      double saturation,
      double vibrance,
      double temperature,
      double sepia,
      double grain});
}

/// @nodoc
class _$EffectCopyWithImpl<$Res, $Val extends Effect>
    implements $EffectCopyWith<$Res> {
  _$EffectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Effect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brightness = null,
    Object? contrast = null,
    Object? saturation = null,
    Object? vibrance = null,
    Object? temperature = null,
    Object? sepia = null,
    Object? grain = null,
  }) {
    return _then(_value.copyWith(
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as double,
      contrast: null == contrast
          ? _value.contrast
          : contrast // ignore: cast_nullable_to_non_nullable
              as double,
      saturation: null == saturation
          ? _value.saturation
          : saturation // ignore: cast_nullable_to_non_nullable
              as double,
      vibrance: null == vibrance
          ? _value.vibrance
          : vibrance // ignore: cast_nullable_to_non_nullable
              as double,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      sepia: null == sepia
          ? _value.sepia
          : sepia // ignore: cast_nullable_to_non_nullable
              as double,
      grain: null == grain
          ? _value.grain
          : grain // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EffectImplCopyWith<$Res> implements $EffectCopyWith<$Res> {
  factory _$$EffectImplCopyWith(
          _$EffectImpl value, $Res Function(_$EffectImpl) then) =
      __$$EffectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double brightness,
      double contrast,
      double saturation,
      double vibrance,
      double temperature,
      double sepia,
      double grain});
}

/// @nodoc
class __$$EffectImplCopyWithImpl<$Res>
    extends _$EffectCopyWithImpl<$Res, _$EffectImpl>
    implements _$$EffectImplCopyWith<$Res> {
  __$$EffectImplCopyWithImpl(
      _$EffectImpl _value, $Res Function(_$EffectImpl) _then)
      : super(_value, _then);

  /// Create a copy of Effect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brightness = null,
    Object? contrast = null,
    Object? saturation = null,
    Object? vibrance = null,
    Object? temperature = null,
    Object? sepia = null,
    Object? grain = null,
  }) {
    return _then(_$EffectImpl(
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as double,
      contrast: null == contrast
          ? _value.contrast
          : contrast // ignore: cast_nullable_to_non_nullable
              as double,
      saturation: null == saturation
          ? _value.saturation
          : saturation // ignore: cast_nullable_to_non_nullable
              as double,
      vibrance: null == vibrance
          ? _value.vibrance
          : vibrance // ignore: cast_nullable_to_non_nullable
              as double,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      sepia: null == sepia
          ? _value.sepia
          : sepia // ignore: cast_nullable_to_non_nullable
              as double,
      grain: null == grain
          ? _value.grain
          : grain // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EffectImpl extends _Effect {
  const _$EffectImpl(
      {this.brightness = 0.0,
      this.contrast = 1.0,
      this.saturation = 1.0,
      this.vibrance = 0.0,
      this.temperature = 0.0,
      this.sepia = 0.0,
      this.grain = 0.0})
      : super._();

  factory _$EffectImpl.fromJson(Map<String, dynamic> json) =>
      _$$EffectImplFromJson(json);

  @override
  @JsonKey()
  final double brightness;
  @override
  @JsonKey()
  final double contrast;
  @override
  @JsonKey()
  final double saturation;
  @override
  @JsonKey()
  final double vibrance;
  @override
  @JsonKey()
  final double temperature;
  @override
  @JsonKey()
  final double sepia;
  @override
  @JsonKey()
  final double grain;

  @override
  String toString() {
    return 'Effect(brightness: $brightness, contrast: $contrast, saturation: $saturation, vibrance: $vibrance, temperature: $temperature, sepia: $sepia, grain: $grain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EffectImpl &&
            (identical(other.brightness, brightness) ||
                other.brightness == brightness) &&
            (identical(other.contrast, contrast) ||
                other.contrast == contrast) &&
            (identical(other.saturation, saturation) ||
                other.saturation == saturation) &&
            (identical(other.vibrance, vibrance) ||
                other.vibrance == vibrance) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.sepia, sepia) || other.sepia == sepia) &&
            (identical(other.grain, grain) || other.grain == grain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, brightness, contrast, saturation,
      vibrance, temperature, sepia, grain);

  /// Create a copy of Effect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EffectImplCopyWith<_$EffectImpl> get copyWith =>
      __$$EffectImplCopyWithImpl<_$EffectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EffectImplToJson(
      this,
    );
  }
}

abstract class _Effect extends Effect {
  const factory _Effect(
      {final double brightness,
      final double contrast,
      final double saturation,
      final double vibrance,
      final double temperature,
      final double sepia,
      final double grain}) = _$EffectImpl;
  const _Effect._() : super._();

  factory _Effect.fromJson(Map<String, dynamic> json) = _$EffectImpl.fromJson;

  @override
  double get brightness;
  @override
  double get contrast;
  @override
  double get saturation;
  @override
  double get vibrance;
  @override
  double get temperature;
  @override
  double get sepia;
  @override
  double get grain;

  /// Create a copy of Effect
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EffectImplCopyWith<_$EffectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
