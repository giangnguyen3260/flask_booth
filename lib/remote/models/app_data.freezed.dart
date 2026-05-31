// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppData _$AppDataFromJson(Map<String, dynamic> json) {
  return _AppData.fromJson(json);
}

/// @nodoc
mixin _$AppData {
  @JsonKey(name: 'framesInfo')
  List<FramesInfo>? get framesInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'configInfo')
  ConfigInfo? get configInfo => throw _privateConstructorUsedError;

  /// Serializes this AppData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppDataCopyWith<AppData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDataCopyWith<$Res> {
  factory $AppDataCopyWith(AppData value, $Res Function(AppData) then) =
      _$AppDataCopyWithImpl<$Res, AppData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'framesInfo') List<FramesInfo>? framesInfo,
      @JsonKey(name: 'configInfo') ConfigInfo? configInfo});

  $ConfigInfoCopyWith<$Res>? get configInfo;
}

/// @nodoc
class _$AppDataCopyWithImpl<$Res, $Val extends AppData>
    implements $AppDataCopyWith<$Res> {
  _$AppDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? framesInfo = freezed,
    Object? configInfo = freezed,
  }) {
    return _then(_value.copyWith(
      framesInfo: freezed == framesInfo
          ? _value.framesInfo
          : framesInfo // ignore: cast_nullable_to_non_nullable
              as List<FramesInfo>?,
      configInfo: freezed == configInfo
          ? _value.configInfo
          : configInfo // ignore: cast_nullable_to_non_nullable
              as ConfigInfo?,
    ) as $Val);
  }

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConfigInfoCopyWith<$Res>? get configInfo {
    if (_value.configInfo == null) {
      return null;
    }

    return $ConfigInfoCopyWith<$Res>(_value.configInfo!, (value) {
      return _then(_value.copyWith(configInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppDataImplCopyWith<$Res> implements $AppDataCopyWith<$Res> {
  factory _$$AppDataImplCopyWith(
          _$AppDataImpl value, $Res Function(_$AppDataImpl) then) =
      __$$AppDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'framesInfo') List<FramesInfo>? framesInfo,
      @JsonKey(name: 'configInfo') ConfigInfo? configInfo});

  @override
  $ConfigInfoCopyWith<$Res>? get configInfo;
}

/// @nodoc
class __$$AppDataImplCopyWithImpl<$Res>
    extends _$AppDataCopyWithImpl<$Res, _$AppDataImpl>
    implements _$$AppDataImplCopyWith<$Res> {
  __$$AppDataImplCopyWithImpl(
      _$AppDataImpl _value, $Res Function(_$AppDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? framesInfo = freezed,
    Object? configInfo = freezed,
  }) {
    return _then(_$AppDataImpl(
      framesInfo: freezed == framesInfo
          ? _value._framesInfo
          : framesInfo // ignore: cast_nullable_to_non_nullable
              as List<FramesInfo>?,
      configInfo: freezed == configInfo
          ? _value.configInfo
          : configInfo // ignore: cast_nullable_to_non_nullable
              as ConfigInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppDataImpl implements _AppData {
  const _$AppDataImpl(
      {@JsonKey(name: 'framesInfo') final List<FramesInfo>? framesInfo,
      @JsonKey(name: 'configInfo') this.configInfo})
      : _framesInfo = framesInfo;

  factory _$AppDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppDataImplFromJson(json);

  final List<FramesInfo>? _framesInfo;
  @override
  @JsonKey(name: 'framesInfo')
  List<FramesInfo>? get framesInfo {
    final value = _framesInfo;
    if (value == null) return null;
    if (_framesInfo is EqualUnmodifiableListView) return _framesInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'configInfo')
  final ConfigInfo? configInfo;

  @override
  String toString() {
    return 'AppData(framesInfo: $framesInfo, configInfo: $configInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDataImpl &&
            const DeepCollectionEquality()
                .equals(other._framesInfo, _framesInfo) &&
            (identical(other.configInfo, configInfo) ||
                other.configInfo == configInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_framesInfo), configInfo);

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDataImplCopyWith<_$AppDataImpl> get copyWith =>
      __$$AppDataImplCopyWithImpl<_$AppDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppDataImplToJson(
      this,
    );
  }
}

abstract class _AppData implements AppData {
  const factory _AppData(
          {@JsonKey(name: 'framesInfo') final List<FramesInfo>? framesInfo,
          @JsonKey(name: 'configInfo') final ConfigInfo? configInfo}) =
      _$AppDataImpl;

  factory _AppData.fromJson(Map<String, dynamic> json) = _$AppDataImpl.fromJson;

  @override
  @JsonKey(name: 'framesInfo')
  List<FramesInfo>? get framesInfo;
  @override
  @JsonKey(name: 'configInfo')
  ConfigInfo? get configInfo;

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppDataImplCopyWith<_$AppDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfigInfo _$ConfigInfoFromJson(Map<String, dynamic> json) {
  return _ConfigInfo.fromJson(json);
}

/// @nodoc
mixin _$ConfigInfo {
  @JsonKey(name: 'timer')
  List<Timer>? get timer => throw _privateConstructorUsedError;
  @JsonKey(name: 'configVersion')
  int? get configVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'appConfig')
  List<AppConfigItem>? get appConfig => throw _privateConstructorUsedError;

  /// Serializes this ConfigInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfigInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigInfoCopyWith<ConfigInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigInfoCopyWith<$Res> {
  factory $ConfigInfoCopyWith(
          ConfigInfo value, $Res Function(ConfigInfo) then) =
      _$ConfigInfoCopyWithImpl<$Res, ConfigInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'timer') List<Timer>? timer,
      @JsonKey(name: 'configVersion') int? configVersion,
      @JsonKey(name: 'appConfig') List<AppConfigItem>? appConfig});
}

/// @nodoc
class _$ConfigInfoCopyWithImpl<$Res, $Val extends ConfigInfo>
    implements $ConfigInfoCopyWith<$Res> {
  _$ConfigInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timer = freezed,
    Object? configVersion = freezed,
    Object? appConfig = freezed,
  }) {
    return _then(_value.copyWith(
      timer: freezed == timer
          ? _value.timer
          : timer // ignore: cast_nullable_to_non_nullable
              as List<Timer>?,
      configVersion: freezed == configVersion
          ? _value.configVersion
          : configVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      appConfig: freezed == appConfig
          ? _value.appConfig
          : appConfig // ignore: cast_nullable_to_non_nullable
              as List<AppConfigItem>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfigInfoImplCopyWith<$Res>
    implements $ConfigInfoCopyWith<$Res> {
  factory _$$ConfigInfoImplCopyWith(
          _$ConfigInfoImpl value, $Res Function(_$ConfigInfoImpl) then) =
      __$$ConfigInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'timer') List<Timer>? timer,
      @JsonKey(name: 'configVersion') int? configVersion,
      @JsonKey(name: 'appConfig') List<AppConfigItem>? appConfig});
}

/// @nodoc
class __$$ConfigInfoImplCopyWithImpl<$Res>
    extends _$ConfigInfoCopyWithImpl<$Res, _$ConfigInfoImpl>
    implements _$$ConfigInfoImplCopyWith<$Res> {
  __$$ConfigInfoImplCopyWithImpl(
      _$ConfigInfoImpl _value, $Res Function(_$ConfigInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConfigInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timer = freezed,
    Object? configVersion = freezed,
    Object? appConfig = freezed,
  }) {
    return _then(_$ConfigInfoImpl(
      timer: freezed == timer
          ? _value._timer
          : timer // ignore: cast_nullable_to_non_nullable
              as List<Timer>?,
      configVersion: freezed == configVersion
          ? _value.configVersion
          : configVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      appConfig: freezed == appConfig
          ? _value._appConfig
          : appConfig // ignore: cast_nullable_to_non_nullable
              as List<AppConfigItem>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigInfoImpl implements _ConfigInfo {
  const _$ConfigInfoImpl(
      {@JsonKey(name: 'timer') final List<Timer>? timer,
      @JsonKey(name: 'configVersion') this.configVersion,
      @JsonKey(name: 'appConfig') final List<AppConfigItem>? appConfig})
      : _timer = timer,
        _appConfig = appConfig;

  factory _$ConfigInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigInfoImplFromJson(json);

  final List<Timer>? _timer;
  @override
  @JsonKey(name: 'timer')
  List<Timer>? get timer {
    final value = _timer;
    if (value == null) return null;
    if (_timer is EqualUnmodifiableListView) return _timer;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'configVersion')
  final int? configVersion;
  final List<AppConfigItem>? _appConfig;
  @override
  @JsonKey(name: 'appConfig')
  List<AppConfigItem>? get appConfig {
    final value = _appConfig;
    if (value == null) return null;
    if (_appConfig is EqualUnmodifiableListView) return _appConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ConfigInfo(timer: $timer, configVersion: $configVersion, appConfig: $appConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigInfoImpl &&
            const DeepCollectionEquality().equals(other._timer, _timer) &&
            (identical(other.configVersion, configVersion) ||
                other.configVersion == configVersion) &&
            const DeepCollectionEquality()
                .equals(other._appConfig, _appConfig));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timer),
      configVersion,
      const DeepCollectionEquality().hash(_appConfig));

  /// Create a copy of ConfigInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigInfoImplCopyWith<_$ConfigInfoImpl> get copyWith =>
      __$$ConfigInfoImplCopyWithImpl<_$ConfigInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigInfoImplToJson(
      this,
    );
  }
}

abstract class _ConfigInfo implements ConfigInfo {
  const factory _ConfigInfo(
          {@JsonKey(name: 'timer') final List<Timer>? timer,
          @JsonKey(name: 'configVersion') final int? configVersion,
          @JsonKey(name: 'appConfig') final List<AppConfigItem>? appConfig}) =
      _$ConfigInfoImpl;

  factory _ConfigInfo.fromJson(Map<String, dynamic> json) =
      _$ConfigInfoImpl.fromJson;

  @override
  @JsonKey(name: 'timer')
  List<Timer>? get timer;
  @override
  @JsonKey(name: 'configVersion')
  int? get configVersion;
  @override
  @JsonKey(name: 'appConfig')
  List<AppConfigItem>? get appConfig;

  /// Create a copy of ConfigInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigInfoImplCopyWith<_$ConfigInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Timer _$TimerFromJson(Map<String, dynamic> json) {
  return _Timer.fromJson(json);
}

/// @nodoc
mixin _$Timer {
  @JsonKey(name: 'screenIndex')
  int? get screenIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'screenCd')
  String? get screenCd => throw _privateConstructorUsedError;
  @JsonKey(name: 'nextScreenCd')
  String? get nextScreenCd => throw _privateConstructorUsedError;
  @JsonKey(name: 'value')
  int? get value => throw _privateConstructorUsedError;

  /// Serializes this Timer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Timer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimerCopyWith<Timer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerCopyWith<$Res> {
  factory $TimerCopyWith(Timer value, $Res Function(Timer) then) =
      _$TimerCopyWithImpl<$Res, Timer>;
  @useResult
  $Res call(
      {@JsonKey(name: 'screenIndex') int? screenIndex,
      @JsonKey(name: 'screenCd') String? screenCd,
      @JsonKey(name: 'nextScreenCd') String? nextScreenCd,
      @JsonKey(name: 'value') int? value});
}

/// @nodoc
class _$TimerCopyWithImpl<$Res, $Val extends Timer>
    implements $TimerCopyWith<$Res> {
  _$TimerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Timer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenIndex = freezed,
    Object? screenCd = freezed,
    Object? nextScreenCd = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      screenIndex: freezed == screenIndex
          ? _value.screenIndex
          : screenIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      screenCd: freezed == screenCd
          ? _value.screenCd
          : screenCd // ignore: cast_nullable_to_non_nullable
              as String?,
      nextScreenCd: freezed == nextScreenCd
          ? _value.nextScreenCd
          : nextScreenCd // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimerImplCopyWith<$Res> implements $TimerCopyWith<$Res> {
  factory _$$TimerImplCopyWith(
          _$TimerImpl value, $Res Function(_$TimerImpl) then) =
      __$$TimerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'screenIndex') int? screenIndex,
      @JsonKey(name: 'screenCd') String? screenCd,
      @JsonKey(name: 'nextScreenCd') String? nextScreenCd,
      @JsonKey(name: 'value') int? value});
}

/// @nodoc
class __$$TimerImplCopyWithImpl<$Res>
    extends _$TimerCopyWithImpl<$Res, _$TimerImpl>
    implements _$$TimerImplCopyWith<$Res> {
  __$$TimerImplCopyWithImpl(
      _$TimerImpl _value, $Res Function(_$TimerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Timer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenIndex = freezed,
    Object? screenCd = freezed,
    Object? nextScreenCd = freezed,
    Object? value = freezed,
  }) {
    return _then(_$TimerImpl(
      screenIndex: freezed == screenIndex
          ? _value.screenIndex
          : screenIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      screenCd: freezed == screenCd
          ? _value.screenCd
          : screenCd // ignore: cast_nullable_to_non_nullable
              as String?,
      nextScreenCd: freezed == nextScreenCd
          ? _value.nextScreenCd
          : nextScreenCd // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerImpl implements _Timer {
  const _$TimerImpl(
      {@JsonKey(name: 'screenIndex') this.screenIndex,
      @JsonKey(name: 'screenCd') this.screenCd,
      @JsonKey(name: 'nextScreenCd') this.nextScreenCd,
      @JsonKey(name: 'value') this.value});

  factory _$TimerImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerImplFromJson(json);

  @override
  @JsonKey(name: 'screenIndex')
  final int? screenIndex;
  @override
  @JsonKey(name: 'screenCd')
  final String? screenCd;
  @override
  @JsonKey(name: 'nextScreenCd')
  final String? nextScreenCd;
  @override
  @JsonKey(name: 'value')
  final int? value;

  @override
  String toString() {
    return 'Timer(screenIndex: $screenIndex, screenCd: $screenCd, nextScreenCd: $nextScreenCd, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerImpl &&
            (identical(other.screenIndex, screenIndex) ||
                other.screenIndex == screenIndex) &&
            (identical(other.screenCd, screenCd) ||
                other.screenCd == screenCd) &&
            (identical(other.nextScreenCd, nextScreenCd) ||
                other.nextScreenCd == nextScreenCd) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, screenIndex, screenCd, nextScreenCd, value);

  /// Create a copy of Timer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerImplCopyWith<_$TimerImpl> get copyWith =>
      __$$TimerImplCopyWithImpl<_$TimerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerImplToJson(
      this,
    );
  }
}

abstract class _Timer implements Timer {
  const factory _Timer(
      {@JsonKey(name: 'screenIndex') final int? screenIndex,
      @JsonKey(name: 'screenCd') final String? screenCd,
      @JsonKey(name: 'nextScreenCd') final String? nextScreenCd,
      @JsonKey(name: 'value') final int? value}) = _$TimerImpl;

  factory _Timer.fromJson(Map<String, dynamic> json) = _$TimerImpl.fromJson;

  @override
  @JsonKey(name: 'screenIndex')
  int? get screenIndex;
  @override
  @JsonKey(name: 'screenCd')
  String? get screenCd;
  @override
  @JsonKey(name: 'nextScreenCd')
  String? get nextScreenCd;
  @override
  @JsonKey(name: 'value')
  int? get value;

  /// Create a copy of Timer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerImplCopyWith<_$TimerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppConfigItem _$AppConfigItemFromJson(Map<String, dynamic> json) {
  return _AppConfigItem.fromJson(json);
}

/// @nodoc
mixin _$AppConfigItem {
  @JsonKey(name: 'configKey')
  String? get configKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'version')
  int? get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'value')
  Map<String, Object?>? get value => throw _privateConstructorUsedError;

  /// Serializes this AppConfigItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppConfigItemCopyWith<AppConfigItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigItemCopyWith<$Res> {
  factory $AppConfigItemCopyWith(
          AppConfigItem value, $Res Function(AppConfigItem) then) =
      _$AppConfigItemCopyWithImpl<$Res, AppConfigItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'configKey') String? configKey,
      @JsonKey(name: 'version') int? version,
      @JsonKey(name: 'value') Map<String, Object?>? value});
}

/// @nodoc
class _$AppConfigItemCopyWithImpl<$Res, $Val extends AppConfigItem>
    implements $AppConfigItemCopyWith<$Res> {
  _$AppConfigItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configKey = freezed,
    Object? version = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      configKey: freezed == configKey
          ? _value.configKey
          : configKey // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppConfigItemImplCopyWith<$Res>
    implements $AppConfigItemCopyWith<$Res> {
  factory _$$AppConfigItemImplCopyWith(
          _$AppConfigItemImpl value, $Res Function(_$AppConfigItemImpl) then) =
      __$$AppConfigItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'configKey') String? configKey,
      @JsonKey(name: 'version') int? version,
      @JsonKey(name: 'value') Map<String, Object?>? value});
}

/// @nodoc
class __$$AppConfigItemImplCopyWithImpl<$Res>
    extends _$AppConfigItemCopyWithImpl<$Res, _$AppConfigItemImpl>
    implements _$$AppConfigItemImplCopyWith<$Res> {
  __$$AppConfigItemImplCopyWithImpl(
      _$AppConfigItemImpl _value, $Res Function(_$AppConfigItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configKey = freezed,
    Object? version = freezed,
    Object? value = freezed,
  }) {
    return _then(_$AppConfigItemImpl(
      configKey: freezed == configKey
          ? _value.configKey
          : configKey // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value._value
          : value // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppConfigItemImpl implements _AppConfigItem {
  const _$AppConfigItemImpl(
      {@JsonKey(name: 'configKey') this.configKey,
      @JsonKey(name: 'version') this.version,
      @JsonKey(name: 'value') final Map<String, Object?>? value})
      : _value = value;

  factory _$AppConfigItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppConfigItemImplFromJson(json);

  @override
  @JsonKey(name: 'configKey')
  final String? configKey;
  @override
  @JsonKey(name: 'version')
  final int? version;
  final Map<String, Object?>? _value;
  @override
  @JsonKey(name: 'value')
  Map<String, Object?>? get value {
    final value = _value;
    if (value == null) return null;
    if (_value is EqualUnmodifiableMapView) return _value;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AppConfigItem(configKey: $configKey, version: $version, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConfigItemImpl &&
            (identical(other.configKey, configKey) ||
                other.configKey == configKey) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other._value, _value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, configKey, version,
      const DeepCollectionEquality().hash(_value));

  /// Create a copy of AppConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConfigItemImplCopyWith<_$AppConfigItemImpl> get copyWith =>
      __$$AppConfigItemImplCopyWithImpl<_$AppConfigItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppConfigItemImplToJson(
      this,
    );
  }
}

abstract class _AppConfigItem implements AppConfigItem {
  const factory _AppConfigItem(
          {@JsonKey(name: 'configKey') final String? configKey,
          @JsonKey(name: 'version') final int? version,
          @JsonKey(name: 'value') final Map<String, Object?>? value}) =
      _$AppConfigItemImpl;

  factory _AppConfigItem.fromJson(Map<String, dynamic> json) =
      _$AppConfigItemImpl.fromJson;

  @override
  @JsonKey(name: 'configKey')
  String? get configKey;
  @override
  @JsonKey(name: 'version')
  int? get version;
  @override
  @JsonKey(name: 'value')
  Map<String, Object?>? get value;

  /// Create a copy of AppConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppConfigItemImplCopyWith<_$AppConfigItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FramesInfo _$FramesInfoFromJson(Map<String, dynamic> json) {
  return _FramesInfo.fromJson(json);
}

/// @nodoc
mixin _$FramesInfo {
  @JsonKey(name: 'frameCd')
  String? get frameCd => throw _privateConstructorUsedError;
  @JsonKey(name: 'frameUrl')
  String? get frameUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'frameUrlTempDis')
  String? get frameUrlTempDis => throw _privateConstructorUsedError;
  @JsonKey(name: 'verticalYn')
  String? get verticalYn => throw _privateConstructorUsedError;
  @JsonKey(name: 'cutYn')
  String? get cutYn => throw _privateConstructorUsedError;
  @JsonKey(name: 'transparent')
  String? get transparent => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  String? get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  String? get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'printQuantity')
  String? get printQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'price')
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'frameSetting')
  FrameSetting? get frameSetting => throw _privateConstructorUsedError;
  @JsonKey(name: 'backgroundInfo')
  List<BackgroundInfo>? get backgroundInfo =>
      throw _privateConstructorUsedError;

  /// Serializes this FramesInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FramesInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FramesInfoCopyWith<FramesInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FramesInfoCopyWith<$Res> {
  factory $FramesInfoCopyWith(
          FramesInfo value, $Res Function(FramesInfo) then) =
      _$FramesInfoCopyWithImpl<$Res, FramesInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'frameCd') String? frameCd,
      @JsonKey(name: 'frameUrl') String? frameUrl,
      @JsonKey(name: 'frameUrlTempDis') String? frameUrlTempDis,
      @JsonKey(name: 'verticalYn') String? verticalYn,
      @JsonKey(name: 'cutYn') String? cutYn,
      @JsonKey(name: 'transparent') String? transparent,
      @JsonKey(name: 'width') String? width,
      @JsonKey(name: 'height') String? height,
      @JsonKey(name: 'printQuantity') String? printQuantity,
      @JsonKey(name: 'price') double? price,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'frameSetting') FrameSetting? frameSetting,
      @JsonKey(name: 'backgroundInfo') List<BackgroundInfo>? backgroundInfo});

  $FrameSettingCopyWith<$Res>? get frameSetting;
}

/// @nodoc
class _$FramesInfoCopyWithImpl<$Res, $Val extends FramesInfo>
    implements $FramesInfoCopyWith<$Res> {
  _$FramesInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FramesInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frameCd = freezed,
    Object? frameUrl = freezed,
    Object? frameUrlTempDis = freezed,
    Object? verticalYn = freezed,
    Object? cutYn = freezed,
    Object? transparent = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? printQuantity = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? frameSetting = freezed,
    Object? backgroundInfo = freezed,
  }) {
    return _then(_value.copyWith(
      frameCd: freezed == frameCd
          ? _value.frameCd
          : frameCd // ignore: cast_nullable_to_non_nullable
              as String?,
      frameUrl: freezed == frameUrl
          ? _value.frameUrl
          : frameUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      frameUrlTempDis: freezed == frameUrlTempDis
          ? _value.frameUrlTempDis
          : frameUrlTempDis // ignore: cast_nullable_to_non_nullable
              as String?,
      verticalYn: freezed == verticalYn
          ? _value.verticalYn
          : verticalYn // ignore: cast_nullable_to_non_nullable
              as String?,
      cutYn: freezed == cutYn
          ? _value.cutYn
          : cutYn // ignore: cast_nullable_to_non_nullable
              as String?,
      transparent: freezed == transparent
          ? _value.transparent
          : transparent // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as String?,
      printQuantity: freezed == printQuantity
          ? _value.printQuantity
          : printQuantity // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      frameSetting: freezed == frameSetting
          ? _value.frameSetting
          : frameSetting // ignore: cast_nullable_to_non_nullable
              as FrameSetting?,
      backgroundInfo: freezed == backgroundInfo
          ? _value.backgroundInfo
          : backgroundInfo // ignore: cast_nullable_to_non_nullable
              as List<BackgroundInfo>?,
    ) as $Val);
  }

  /// Create a copy of FramesInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FrameSettingCopyWith<$Res>? get frameSetting {
    if (_value.frameSetting == null) {
      return null;
    }

    return $FrameSettingCopyWith<$Res>(_value.frameSetting!, (value) {
      return _then(_value.copyWith(frameSetting: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FramesInfoImplCopyWith<$Res>
    implements $FramesInfoCopyWith<$Res> {
  factory _$$FramesInfoImplCopyWith(
          _$FramesInfoImpl value, $Res Function(_$FramesInfoImpl) then) =
      __$$FramesInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'frameCd') String? frameCd,
      @JsonKey(name: 'frameUrl') String? frameUrl,
      @JsonKey(name: 'frameUrlTempDis') String? frameUrlTempDis,
      @JsonKey(name: 'verticalYn') String? verticalYn,
      @JsonKey(name: 'cutYn') String? cutYn,
      @JsonKey(name: 'transparent') String? transparent,
      @JsonKey(name: 'width') String? width,
      @JsonKey(name: 'height') String? height,
      @JsonKey(name: 'printQuantity') String? printQuantity,
      @JsonKey(name: 'price') double? price,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'frameSetting') FrameSetting? frameSetting,
      @JsonKey(name: 'backgroundInfo') List<BackgroundInfo>? backgroundInfo});

  @override
  $FrameSettingCopyWith<$Res>? get frameSetting;
}

/// @nodoc
class __$$FramesInfoImplCopyWithImpl<$Res>
    extends _$FramesInfoCopyWithImpl<$Res, _$FramesInfoImpl>
    implements _$$FramesInfoImplCopyWith<$Res> {
  __$$FramesInfoImplCopyWithImpl(
      _$FramesInfoImpl _value, $Res Function(_$FramesInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of FramesInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frameCd = freezed,
    Object? frameUrl = freezed,
    Object? frameUrlTempDis = freezed,
    Object? verticalYn = freezed,
    Object? cutYn = freezed,
    Object? transparent = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? printQuantity = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? frameSetting = freezed,
    Object? backgroundInfo = freezed,
  }) {
    return _then(_$FramesInfoImpl(
      frameCd: freezed == frameCd
          ? _value.frameCd
          : frameCd // ignore: cast_nullable_to_non_nullable
              as String?,
      frameUrl: freezed == frameUrl
          ? _value.frameUrl
          : frameUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      frameUrlTempDis: freezed == frameUrlTempDis
          ? _value.frameUrlTempDis
          : frameUrlTempDis // ignore: cast_nullable_to_non_nullable
              as String?,
      verticalYn: freezed == verticalYn
          ? _value.verticalYn
          : verticalYn // ignore: cast_nullable_to_non_nullable
              as String?,
      cutYn: freezed == cutYn
          ? _value.cutYn
          : cutYn // ignore: cast_nullable_to_non_nullable
              as String?,
      transparent: freezed == transparent
          ? _value.transparent
          : transparent // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as String?,
      printQuantity: freezed == printQuantity
          ? _value.printQuantity
          : printQuantity // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      frameSetting: freezed == frameSetting
          ? _value.frameSetting
          : frameSetting // ignore: cast_nullable_to_non_nullable
              as FrameSetting?,
      backgroundInfo: freezed == backgroundInfo
          ? _value._backgroundInfo
          : backgroundInfo // ignore: cast_nullable_to_non_nullable
              as List<BackgroundInfo>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FramesInfoImpl extends _FramesInfo {
  const _$FramesInfoImpl(
      {@JsonKey(name: 'frameCd') this.frameCd,
      @JsonKey(name: 'frameUrl') this.frameUrl,
      @JsonKey(name: 'frameUrlTempDis') this.frameUrlTempDis,
      @JsonKey(name: 'verticalYn') this.verticalYn,
      @JsonKey(name: 'cutYn') this.cutYn,
      @JsonKey(name: 'transparent') this.transparent,
      @JsonKey(name: 'width') this.width,
      @JsonKey(name: 'height') this.height,
      @JsonKey(name: 'printQuantity') this.printQuantity,
      @JsonKey(name: 'price') this.price,
      @JsonKey(name: 'currency') this.currency,
      @JsonKey(name: 'frameSetting') this.frameSetting,
      @JsonKey(name: 'backgroundInfo')
      final List<BackgroundInfo>? backgroundInfo})
      : _backgroundInfo = backgroundInfo,
        super._();

  factory _$FramesInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FramesInfoImplFromJson(json);

  @override
  @JsonKey(name: 'frameCd')
  final String? frameCd;
  @override
  @JsonKey(name: 'frameUrl')
  final String? frameUrl;
  @override
  @JsonKey(name: 'frameUrlTempDis')
  final String? frameUrlTempDis;
  @override
  @JsonKey(name: 'verticalYn')
  final String? verticalYn;
  @override
  @JsonKey(name: 'cutYn')
  final String? cutYn;
  @override
  @JsonKey(name: 'transparent')
  final String? transparent;
  @override
  @JsonKey(name: 'width')
  final String? width;
  @override
  @JsonKey(name: 'height')
  final String? height;
  @override
  @JsonKey(name: 'printQuantity')
  final String? printQuantity;
  @override
  @JsonKey(name: 'price')
  final double? price;
  @override
  @JsonKey(name: 'currency')
  final String? currency;
  @override
  @JsonKey(name: 'frameSetting')
  final FrameSetting? frameSetting;
  final List<BackgroundInfo>? _backgroundInfo;
  @override
  @JsonKey(name: 'backgroundInfo')
  List<BackgroundInfo>? get backgroundInfo {
    final value = _backgroundInfo;
    if (value == null) return null;
    if (_backgroundInfo is EqualUnmodifiableListView) return _backgroundInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FramesInfo(frameCd: $frameCd, frameUrl: $frameUrl, frameUrlTempDis: $frameUrlTempDis, verticalYn: $verticalYn, cutYn: $cutYn, transparent: $transparent, width: $width, height: $height, printQuantity: $printQuantity, price: $price, currency: $currency, frameSetting: $frameSetting, backgroundInfo: $backgroundInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FramesInfoImpl &&
            (identical(other.frameCd, frameCd) || other.frameCd == frameCd) &&
            (identical(other.frameUrl, frameUrl) ||
                other.frameUrl == frameUrl) &&
            (identical(other.frameUrlTempDis, frameUrlTempDis) ||
                other.frameUrlTempDis == frameUrlTempDis) &&
            (identical(other.verticalYn, verticalYn) ||
                other.verticalYn == verticalYn) &&
            (identical(other.cutYn, cutYn) || other.cutYn == cutYn) &&
            (identical(other.transparent, transparent) ||
                other.transparent == transparent) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.printQuantity, printQuantity) ||
                other.printQuantity == printQuantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.frameSetting, frameSetting) ||
                other.frameSetting == frameSetting) &&
            const DeepCollectionEquality()
                .equals(other._backgroundInfo, _backgroundInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frameCd,
      frameUrl,
      frameUrlTempDis,
      verticalYn,
      cutYn,
      transparent,
      width,
      height,
      printQuantity,
      price,
      currency,
      frameSetting,
      const DeepCollectionEquality().hash(_backgroundInfo));

  /// Create a copy of FramesInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FramesInfoImplCopyWith<_$FramesInfoImpl> get copyWith =>
      __$$FramesInfoImplCopyWithImpl<_$FramesInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FramesInfoImplToJson(
      this,
    );
  }
}

abstract class _FramesInfo extends FramesInfo {
  const factory _FramesInfo(
      {@JsonKey(name: 'frameCd') final String? frameCd,
      @JsonKey(name: 'frameUrl') final String? frameUrl,
      @JsonKey(name: 'frameUrlTempDis') final String? frameUrlTempDis,
      @JsonKey(name: 'verticalYn') final String? verticalYn,
      @JsonKey(name: 'cutYn') final String? cutYn,
      @JsonKey(name: 'transparent') final String? transparent,
      @JsonKey(name: 'width') final String? width,
      @JsonKey(name: 'height') final String? height,
      @JsonKey(name: 'printQuantity') final String? printQuantity,
      @JsonKey(name: 'price') final double? price,
      @JsonKey(name: 'currency') final String? currency,
      @JsonKey(name: 'frameSetting') final FrameSetting? frameSetting,
      @JsonKey(name: 'backgroundInfo')
      final List<BackgroundInfo>? backgroundInfo}) = _$FramesInfoImpl;
  const _FramesInfo._() : super._();

  factory _FramesInfo.fromJson(Map<String, dynamic> json) =
      _$FramesInfoImpl.fromJson;

  @override
  @JsonKey(name: 'frameCd')
  String? get frameCd;
  @override
  @JsonKey(name: 'frameUrl')
  String? get frameUrl;
  @override
  @JsonKey(name: 'frameUrlTempDis')
  String? get frameUrlTempDis;
  @override
  @JsonKey(name: 'verticalYn')
  String? get verticalYn;
  @override
  @JsonKey(name: 'cutYn')
  String? get cutYn;
  @override
  @JsonKey(name: 'transparent')
  String? get transparent;
  @override
  @JsonKey(name: 'width')
  String? get width;
  @override
  @JsonKey(name: 'height')
  String? get height;
  @override
  @JsonKey(name: 'printQuantity')
  String? get printQuantity;
  @override
  @JsonKey(name: 'price')
  double? get price;
  @override
  @JsonKey(name: 'currency')
  String? get currency;
  @override
  @JsonKey(name: 'frameSetting')
  FrameSetting? get frameSetting;
  @override
  @JsonKey(name: 'backgroundInfo')
  List<BackgroundInfo>? get backgroundInfo;

  /// Create a copy of FramesInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FramesInfoImplCopyWith<_$FramesInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackgroundInfo _$BackgroundInfoFromJson(Map<String, dynamic> json) {
  return _BackgroundInfo.fromJson(json);
}

/// @nodoc
mixin _$BackgroundInfo {
  @JsonKey(name: 'bgCateCd')
  String? get bgCateCd => throw _privateConstructorUsedError;
  @JsonKey(name: 'bgCateNm')
  String? get bgCateNm => throw _privateConstructorUsedError;
  @JsonKey(name: 'bgCateIcon')
  String? get bgCateIcon => throw _privateConstructorUsedError;
  @JsonKey(name: 'background')
  List<Background>? get background => throw _privateConstructorUsedError;

  /// Serializes this BackgroundInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackgroundInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackgroundInfoCopyWith<BackgroundInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackgroundInfoCopyWith<$Res> {
  factory $BackgroundInfoCopyWith(
          BackgroundInfo value, $Res Function(BackgroundInfo) then) =
      _$BackgroundInfoCopyWithImpl<$Res, BackgroundInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'bgCateCd') String? bgCateCd,
      @JsonKey(name: 'bgCateNm') String? bgCateNm,
      @JsonKey(name: 'bgCateIcon') String? bgCateIcon,
      @JsonKey(name: 'background') List<Background>? background});
}

/// @nodoc
class _$BackgroundInfoCopyWithImpl<$Res, $Val extends BackgroundInfo>
    implements $BackgroundInfoCopyWith<$Res> {
  _$BackgroundInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackgroundInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bgCateCd = freezed,
    Object? bgCateNm = freezed,
    Object? bgCateIcon = freezed,
    Object? background = freezed,
  }) {
    return _then(_value.copyWith(
      bgCateCd: freezed == bgCateCd
          ? _value.bgCateCd
          : bgCateCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bgCateNm: freezed == bgCateNm
          ? _value.bgCateNm
          : bgCateNm // ignore: cast_nullable_to_non_nullable
              as String?,
      bgCateIcon: freezed == bgCateIcon
          ? _value.bgCateIcon
          : bgCateIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      background: freezed == background
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as List<Background>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackgroundInfoImplCopyWith<$Res>
    implements $BackgroundInfoCopyWith<$Res> {
  factory _$$BackgroundInfoImplCopyWith(_$BackgroundInfoImpl value,
          $Res Function(_$BackgroundInfoImpl) then) =
      __$$BackgroundInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'bgCateCd') String? bgCateCd,
      @JsonKey(name: 'bgCateNm') String? bgCateNm,
      @JsonKey(name: 'bgCateIcon') String? bgCateIcon,
      @JsonKey(name: 'background') List<Background>? background});
}

/// @nodoc
class __$$BackgroundInfoImplCopyWithImpl<$Res>
    extends _$BackgroundInfoCopyWithImpl<$Res, _$BackgroundInfoImpl>
    implements _$$BackgroundInfoImplCopyWith<$Res> {
  __$$BackgroundInfoImplCopyWithImpl(
      _$BackgroundInfoImpl _value, $Res Function(_$BackgroundInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackgroundInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bgCateCd = freezed,
    Object? bgCateNm = freezed,
    Object? bgCateIcon = freezed,
    Object? background = freezed,
  }) {
    return _then(_$BackgroundInfoImpl(
      bgCateCd: freezed == bgCateCd
          ? _value.bgCateCd
          : bgCateCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bgCateNm: freezed == bgCateNm
          ? _value.bgCateNm
          : bgCateNm // ignore: cast_nullable_to_non_nullable
              as String?,
      bgCateIcon: freezed == bgCateIcon
          ? _value.bgCateIcon
          : bgCateIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      background: freezed == background
          ? _value._background
          : background // ignore: cast_nullable_to_non_nullable
              as List<Background>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackgroundInfoImpl implements _BackgroundInfo {
  const _$BackgroundInfoImpl(
      {@JsonKey(name: 'bgCateCd') this.bgCateCd,
      @JsonKey(name: 'bgCateNm') this.bgCateNm,
      @JsonKey(name: 'bgCateIcon') this.bgCateIcon,
      @JsonKey(name: 'background') final List<Background>? background})
      : _background = background;

  factory _$BackgroundInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackgroundInfoImplFromJson(json);

  @override
  @JsonKey(name: 'bgCateCd')
  final String? bgCateCd;
  @override
  @JsonKey(name: 'bgCateNm')
  final String? bgCateNm;
  @override
  @JsonKey(name: 'bgCateIcon')
  final String? bgCateIcon;
  final List<Background>? _background;
  @override
  @JsonKey(name: 'background')
  List<Background>? get background {
    final value = _background;
    if (value == null) return null;
    if (_background is EqualUnmodifiableListView) return _background;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BackgroundInfo(bgCateCd: $bgCateCd, bgCateNm: $bgCateNm, bgCateIcon: $bgCateIcon, background: $background)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackgroundInfoImpl &&
            (identical(other.bgCateCd, bgCateCd) ||
                other.bgCateCd == bgCateCd) &&
            (identical(other.bgCateNm, bgCateNm) ||
                other.bgCateNm == bgCateNm) &&
            (identical(other.bgCateIcon, bgCateIcon) ||
                other.bgCateIcon == bgCateIcon) &&
            const DeepCollectionEquality()
                .equals(other._background, _background));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bgCateCd, bgCateNm, bgCateIcon,
      const DeepCollectionEquality().hash(_background));

  /// Create a copy of BackgroundInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackgroundInfoImplCopyWith<_$BackgroundInfoImpl> get copyWith =>
      __$$BackgroundInfoImplCopyWithImpl<_$BackgroundInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackgroundInfoImplToJson(
      this,
    );
  }
}

abstract class _BackgroundInfo implements BackgroundInfo {
  const factory _BackgroundInfo(
          {@JsonKey(name: 'bgCateCd') final String? bgCateCd,
          @JsonKey(name: 'bgCateNm') final String? bgCateNm,
          @JsonKey(name: 'bgCateIcon') final String? bgCateIcon,
          @JsonKey(name: 'background') final List<Background>? background}) =
      _$BackgroundInfoImpl;

  factory _BackgroundInfo.fromJson(Map<String, dynamic> json) =
      _$BackgroundInfoImpl.fromJson;

  @override
  @JsonKey(name: 'bgCateCd')
  String? get bgCateCd;
  @override
  @JsonKey(name: 'bgCateNm')
  String? get bgCateNm;
  @override
  @JsonKey(name: 'bgCateIcon')
  String? get bgCateIcon;
  @override
  @JsonKey(name: 'background')
  List<Background>? get background;

  /// Create a copy of BackgroundInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackgroundInfoImplCopyWith<_$BackgroundInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Background _$BackgroundFromJson(Map<String, dynamic> json) {
  return _Background.fromJson(json);
}

/// @nodoc
mixin _$Background {
  @JsonKey(name: 'bgCd')
  String? get bgCd => throw _privateConstructorUsedError;
  @JsonKey(name: 'bgNm')
  String? get bgNm => throw _privateConstructorUsedError;
  @JsonKey(name: 'bgUrl')
  String? get bgUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'maskJson')
  List<BackgroundMaskArea>? get maskJson => throw _privateConstructorUsedError;

  /// Serializes this Background to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Background
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackgroundCopyWith<Background> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackgroundCopyWith<$Res> {
  factory $BackgroundCopyWith(
          Background value, $Res Function(Background) then) =
      _$BackgroundCopyWithImpl<$Res, Background>;
  @useResult
  $Res call(
      {@JsonKey(name: 'bgCd') String? bgCd,
      @JsonKey(name: 'bgNm') String? bgNm,
      @JsonKey(name: 'bgUrl') String? bgUrl,
      @JsonKey(name: 'maskJson') List<BackgroundMaskArea>? maskJson});
}

/// @nodoc
class _$BackgroundCopyWithImpl<$Res, $Val extends Background>
    implements $BackgroundCopyWith<$Res> {
  _$BackgroundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Background
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bgCd = freezed,
    Object? bgNm = freezed,
    Object? bgUrl = freezed,
    Object? maskJson = freezed,
  }) {
    return _then(_value.copyWith(
      bgCd: freezed == bgCd
          ? _value.bgCd
          : bgCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bgNm: freezed == bgNm
          ? _value.bgNm
          : bgNm // ignore: cast_nullable_to_non_nullable
              as String?,
      bgUrl: freezed == bgUrl
          ? _value.bgUrl
          : bgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maskJson: freezed == maskJson
          ? _value.maskJson
          : maskJson // ignore: cast_nullable_to_non_nullable
              as List<BackgroundMaskArea>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackgroundImplCopyWith<$Res>
    implements $BackgroundCopyWith<$Res> {
  factory _$$BackgroundImplCopyWith(
          _$BackgroundImpl value, $Res Function(_$BackgroundImpl) then) =
      __$$BackgroundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'bgCd') String? bgCd,
      @JsonKey(name: 'bgNm') String? bgNm,
      @JsonKey(name: 'bgUrl') String? bgUrl,
      @JsonKey(name: 'maskJson') List<BackgroundMaskArea>? maskJson});
}

/// @nodoc
class __$$BackgroundImplCopyWithImpl<$Res>
    extends _$BackgroundCopyWithImpl<$Res, _$BackgroundImpl>
    implements _$$BackgroundImplCopyWith<$Res> {
  __$$BackgroundImplCopyWithImpl(
      _$BackgroundImpl _value, $Res Function(_$BackgroundImpl) _then)
      : super(_value, _then);

  /// Create a copy of Background
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bgCd = freezed,
    Object? bgNm = freezed,
    Object? bgUrl = freezed,
    Object? maskJson = freezed,
  }) {
    return _then(_$BackgroundImpl(
      bgCd: freezed == bgCd
          ? _value.bgCd
          : bgCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bgNm: freezed == bgNm
          ? _value.bgNm
          : bgNm // ignore: cast_nullable_to_non_nullable
              as String?,
      bgUrl: freezed == bgUrl
          ? _value.bgUrl
          : bgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maskJson: freezed == maskJson
          ? _value._maskJson
          : maskJson // ignore: cast_nullable_to_non_nullable
              as List<BackgroundMaskArea>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackgroundImpl extends _Background {
  const _$BackgroundImpl(
      {@JsonKey(name: 'bgCd') this.bgCd,
      @JsonKey(name: 'bgNm') this.bgNm,
      @JsonKey(name: 'bgUrl') this.bgUrl,
      @JsonKey(name: 'maskJson') final List<BackgroundMaskArea>? maskJson})
      : _maskJson = maskJson,
        super._();

  factory _$BackgroundImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackgroundImplFromJson(json);

  @override
  @JsonKey(name: 'bgCd')
  final String? bgCd;
  @override
  @JsonKey(name: 'bgNm')
  final String? bgNm;
  @override
  @JsonKey(name: 'bgUrl')
  final String? bgUrl;
  final List<BackgroundMaskArea>? _maskJson;
  @override
  @JsonKey(name: 'maskJson')
  List<BackgroundMaskArea>? get maskJson {
    final value = _maskJson;
    if (value == null) return null;
    if (_maskJson is EqualUnmodifiableListView) return _maskJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Background(bgCd: $bgCd, bgNm: $bgNm, bgUrl: $bgUrl, maskJson: $maskJson)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackgroundImpl &&
            (identical(other.bgCd, bgCd) || other.bgCd == bgCd) &&
            (identical(other.bgNm, bgNm) || other.bgNm == bgNm) &&
            (identical(other.bgUrl, bgUrl) || other.bgUrl == bgUrl) &&
            const DeepCollectionEquality().equals(other._maskJson, _maskJson));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bgCd, bgNm, bgUrl,
      const DeepCollectionEquality().hash(_maskJson));

  /// Create a copy of Background
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackgroundImplCopyWith<_$BackgroundImpl> get copyWith =>
      __$$BackgroundImplCopyWithImpl<_$BackgroundImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackgroundImplToJson(
      this,
    );
  }
}

abstract class _Background extends Background {
  const factory _Background(
      {@JsonKey(name: 'bgCd') final String? bgCd,
      @JsonKey(name: 'bgNm') final String? bgNm,
      @JsonKey(name: 'bgUrl') final String? bgUrl,
      @JsonKey(name: 'maskJson')
      final List<BackgroundMaskArea>? maskJson}) = _$BackgroundImpl;
  const _Background._() : super._();

  factory _Background.fromJson(Map<String, dynamic> json) =
      _$BackgroundImpl.fromJson;

  @override
  @JsonKey(name: 'bgCd')
  String? get bgCd;
  @override
  @JsonKey(name: 'bgNm')
  String? get bgNm;
  @override
  @JsonKey(name: 'bgUrl')
  String? get bgUrl;
  @override
  @JsonKey(name: 'maskJson')
  List<BackgroundMaskArea>? get maskJson;

  /// Create a copy of Background
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackgroundImplCopyWith<_$BackgroundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackgroundMaskArea _$BackgroundMaskAreaFromJson(Map<String, dynamic> json) {
  return _BackgroundMaskArea.fromJson(json);
}

/// @nodoc
mixin _$BackgroundMaskArea {
  @JsonKey(name: 'x')
  double get x => throw _privateConstructorUsedError;
  @JsonKey(name: 'y')
  double get y => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  double get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  double get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;

  /// Serializes this BackgroundMaskArea to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackgroundMaskArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackgroundMaskAreaCopyWith<BackgroundMaskArea> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackgroundMaskAreaCopyWith<$Res> {
  factory $BackgroundMaskAreaCopyWith(
          BackgroundMaskArea value, $Res Function(BackgroundMaskArea) then) =
      _$BackgroundMaskAreaCopyWithImpl<$Res, BackgroundMaskArea>;
  @useResult
  $Res call(
      {@JsonKey(name: 'x') double x,
      @JsonKey(name: 'y') double y,
      @JsonKey(name: 'width') double width,
      @JsonKey(name: 'height') double height,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class _$BackgroundMaskAreaCopyWithImpl<$Res, $Val extends BackgroundMaskArea>
    implements $BackgroundMaskAreaCopyWith<$Res> {
  _$BackgroundMaskAreaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackgroundMaskArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackgroundMaskAreaImplCopyWith<$Res>
    implements $BackgroundMaskAreaCopyWith<$Res> {
  factory _$$BackgroundMaskAreaImplCopyWith(_$BackgroundMaskAreaImpl value,
          $Res Function(_$BackgroundMaskAreaImpl) then) =
      __$$BackgroundMaskAreaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'x') double x,
      @JsonKey(name: 'y') double y,
      @JsonKey(name: 'width') double width,
      @JsonKey(name: 'height') double height,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class __$$BackgroundMaskAreaImplCopyWithImpl<$Res>
    extends _$BackgroundMaskAreaCopyWithImpl<$Res, _$BackgroundMaskAreaImpl>
    implements _$$BackgroundMaskAreaImplCopyWith<$Res> {
  __$$BackgroundMaskAreaImplCopyWithImpl(_$BackgroundMaskAreaImpl _value,
      $Res Function(_$BackgroundMaskAreaImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackgroundMaskArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? type = null,
  }) {
    return _then(_$BackgroundMaskAreaImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackgroundMaskAreaImpl extends _BackgroundMaskArea {
  const _$BackgroundMaskAreaImpl(
      {@JsonKey(name: 'x') required this.x,
      @JsonKey(name: 'y') required this.y,
      @JsonKey(name: 'width') required this.width,
      @JsonKey(name: 'height') required this.height,
      @JsonKey(name: 'type') required this.type})
      : super._();

  factory _$BackgroundMaskAreaImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackgroundMaskAreaImplFromJson(json);

  @override
  @JsonKey(name: 'x')
  final double x;
  @override
  @JsonKey(name: 'y')
  final double y;
  @override
  @JsonKey(name: 'width')
  final double width;
  @override
  @JsonKey(name: 'height')
  final double height;
  @override
  @JsonKey(name: 'type')
  final String type;

  @override
  String toString() {
    return 'BackgroundMaskArea(x: $x, y: $y, width: $width, height: $height, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackgroundMaskAreaImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, width, height, type);

  /// Create a copy of BackgroundMaskArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackgroundMaskAreaImplCopyWith<_$BackgroundMaskAreaImpl> get copyWith =>
      __$$BackgroundMaskAreaImplCopyWithImpl<_$BackgroundMaskAreaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackgroundMaskAreaImplToJson(
      this,
    );
  }
}

abstract class _BackgroundMaskArea extends BackgroundMaskArea {
  const factory _BackgroundMaskArea(
          {@JsonKey(name: 'x') required final double x,
          @JsonKey(name: 'y') required final double y,
          @JsonKey(name: 'width') required final double width,
          @JsonKey(name: 'height') required final double height,
          @JsonKey(name: 'type') required final String type}) =
      _$BackgroundMaskAreaImpl;
  const _BackgroundMaskArea._() : super._();

  factory _BackgroundMaskArea.fromJson(Map<String, dynamic> json) =
      _$BackgroundMaskAreaImpl.fromJson;

  @override
  @JsonKey(name: 'x')
  double get x;
  @override
  @JsonKey(name: 'y')
  double get y;
  @override
  @JsonKey(name: 'width')
  double get width;
  @override
  @JsonKey(name: 'height')
  double get height;
  @override
  @JsonKey(name: 'type')
  String get type;

  /// Create a copy of BackgroundMaskArea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackgroundMaskAreaImplCopyWith<_$BackgroundMaskAreaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FrameSetting _$FrameSettingFromJson(Map<String, dynamic> json) {
  return _FrameSetting.fromJson(json);
}

/// @nodoc
mixin _$FrameSetting {
  @JsonKey(name: 'numOfPhotos')
  int? get numOfPhotos => throw _privateConstructorUsedError;
  @JsonKey(name: 'timePerShot')
  int? get timePerShot => throw _privateConstructorUsedError;
  @JsonKey(name: 'additionPrice')
  double? get additionPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'addPhotoNumber')
  int? get addPhotoNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'addPhotoLimit')
  int? get addPhotoLimit => throw _privateConstructorUsedError;

  /// Serializes this FrameSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FrameSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FrameSettingCopyWith<FrameSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FrameSettingCopyWith<$Res> {
  factory $FrameSettingCopyWith(
          FrameSetting value, $Res Function(FrameSetting) then) =
      _$FrameSettingCopyWithImpl<$Res, FrameSetting>;
  @useResult
  $Res call(
      {@JsonKey(name: 'numOfPhotos') int? numOfPhotos,
      @JsonKey(name: 'timePerShot') int? timePerShot,
      @JsonKey(name: 'additionPrice') double? additionPrice,
      @JsonKey(name: 'addPhotoNumber') int? addPhotoNumber,
      @JsonKey(name: 'addPhotoLimit') int? addPhotoLimit});
}

/// @nodoc
class _$FrameSettingCopyWithImpl<$Res, $Val extends FrameSetting>
    implements $FrameSettingCopyWith<$Res> {
  _$FrameSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FrameSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? numOfPhotos = freezed,
    Object? timePerShot = freezed,
    Object? additionPrice = freezed,
    Object? addPhotoNumber = freezed,
    Object? addPhotoLimit = freezed,
  }) {
    return _then(_value.copyWith(
      numOfPhotos: freezed == numOfPhotos
          ? _value.numOfPhotos
          : numOfPhotos // ignore: cast_nullable_to_non_nullable
              as int?,
      timePerShot: freezed == timePerShot
          ? _value.timePerShot
          : timePerShot // ignore: cast_nullable_to_non_nullable
              as int?,
      additionPrice: freezed == additionPrice
          ? _value.additionPrice
          : additionPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      addPhotoNumber: freezed == addPhotoNumber
          ? _value.addPhotoNumber
          : addPhotoNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      addPhotoLimit: freezed == addPhotoLimit
          ? _value.addPhotoLimit
          : addPhotoLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FrameSettingImplCopyWith<$Res>
    implements $FrameSettingCopyWith<$Res> {
  factory _$$FrameSettingImplCopyWith(
          _$FrameSettingImpl value, $Res Function(_$FrameSettingImpl) then) =
      __$$FrameSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'numOfPhotos') int? numOfPhotos,
      @JsonKey(name: 'timePerShot') int? timePerShot,
      @JsonKey(name: 'additionPrice') double? additionPrice,
      @JsonKey(name: 'addPhotoNumber') int? addPhotoNumber,
      @JsonKey(name: 'addPhotoLimit') int? addPhotoLimit});
}

/// @nodoc
class __$$FrameSettingImplCopyWithImpl<$Res>
    extends _$FrameSettingCopyWithImpl<$Res, _$FrameSettingImpl>
    implements _$$FrameSettingImplCopyWith<$Res> {
  __$$FrameSettingImplCopyWithImpl(
      _$FrameSettingImpl _value, $Res Function(_$FrameSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of FrameSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? numOfPhotos = freezed,
    Object? timePerShot = freezed,
    Object? additionPrice = freezed,
    Object? addPhotoNumber = freezed,
    Object? addPhotoLimit = freezed,
  }) {
    return _then(_$FrameSettingImpl(
      numOfPhotos: freezed == numOfPhotos
          ? _value.numOfPhotos
          : numOfPhotos // ignore: cast_nullable_to_non_nullable
              as int?,
      timePerShot: freezed == timePerShot
          ? _value.timePerShot
          : timePerShot // ignore: cast_nullable_to_non_nullable
              as int?,
      additionPrice: freezed == additionPrice
          ? _value.additionPrice
          : additionPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      addPhotoNumber: freezed == addPhotoNumber
          ? _value.addPhotoNumber
          : addPhotoNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      addPhotoLimit: freezed == addPhotoLimit
          ? _value.addPhotoLimit
          : addPhotoLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FrameSettingImpl implements _FrameSetting {
  const _$FrameSettingImpl(
      {@JsonKey(name: 'numOfPhotos') this.numOfPhotos,
      @JsonKey(name: 'timePerShot') this.timePerShot,
      @JsonKey(name: 'additionPrice') this.additionPrice,
      @JsonKey(name: 'addPhotoNumber') this.addPhotoNumber,
      @JsonKey(name: 'addPhotoLimit') this.addPhotoLimit});

  factory _$FrameSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$FrameSettingImplFromJson(json);

  @override
  @JsonKey(name: 'numOfPhotos')
  final int? numOfPhotos;
  @override
  @JsonKey(name: 'timePerShot')
  final int? timePerShot;
  @override
  @JsonKey(name: 'additionPrice')
  final double? additionPrice;
  @override
  @JsonKey(name: 'addPhotoNumber')
  final int? addPhotoNumber;
  @override
  @JsonKey(name: 'addPhotoLimit')
  final int? addPhotoLimit;

  @override
  String toString() {
    return 'FrameSetting(numOfPhotos: $numOfPhotos, timePerShot: $timePerShot, additionPrice: $additionPrice, addPhotoNumber: $addPhotoNumber, addPhotoLimit: $addPhotoLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FrameSettingImpl &&
            (identical(other.numOfPhotos, numOfPhotos) ||
                other.numOfPhotos == numOfPhotos) &&
            (identical(other.timePerShot, timePerShot) ||
                other.timePerShot == timePerShot) &&
            (identical(other.additionPrice, additionPrice) ||
                other.additionPrice == additionPrice) &&
            (identical(other.addPhotoNumber, addPhotoNumber) ||
                other.addPhotoNumber == addPhotoNumber) &&
            (identical(other.addPhotoLimit, addPhotoLimit) ||
                other.addPhotoLimit == addPhotoLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, numOfPhotos, timePerShot,
      additionPrice, addPhotoNumber, addPhotoLimit);

  /// Create a copy of FrameSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FrameSettingImplCopyWith<_$FrameSettingImpl> get copyWith =>
      __$$FrameSettingImplCopyWithImpl<_$FrameSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FrameSettingImplToJson(
      this,
    );
  }
}

abstract class _FrameSetting implements FrameSetting {
  const factory _FrameSetting(
          {@JsonKey(name: 'numOfPhotos') final int? numOfPhotos,
          @JsonKey(name: 'timePerShot') final int? timePerShot,
          @JsonKey(name: 'additionPrice') final double? additionPrice,
          @JsonKey(name: 'addPhotoNumber') final int? addPhotoNumber,
          @JsonKey(name: 'addPhotoLimit') final int? addPhotoLimit}) =
      _$FrameSettingImpl;

  factory _FrameSetting.fromJson(Map<String, dynamic> json) =
      _$FrameSettingImpl.fromJson;

  @override
  @JsonKey(name: 'numOfPhotos')
  int? get numOfPhotos;
  @override
  @JsonKey(name: 'timePerShot')
  int? get timePerShot;
  @override
  @JsonKey(name: 'additionPrice')
  double? get additionPrice;
  @override
  @JsonKey(name: 'addPhotoNumber')
  int? get addPhotoNumber;
  @override
  @JsonKey(name: 'addPhotoLimit')
  int? get addPhotoLimit;

  /// Create a copy of FrameSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FrameSettingImplCopyWith<_$FrameSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
