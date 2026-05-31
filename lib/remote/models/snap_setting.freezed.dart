// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snap_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SnapSetting _$SnapSettingFromJson(Map<String, dynamic> json) {
  return _SnapSetting.fromJson(json);
}

/// @nodoc
mixin _$SnapSetting {
  @JsonKey(name: 'core')
  Core? get core => throw _privateConstructorUsedError;
  @JsonKey(name: 'lenses')
  Lenses? get lenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'settings')
  Settings? get settings => throw _privateConstructorUsedError;

  /// Serializes this SnapSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SnapSettingCopyWith<SnapSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnapSettingCopyWith<$Res> {
  factory $SnapSettingCopyWith(
          SnapSetting value, $Res Function(SnapSetting) then) =
      _$SnapSettingCopyWithImpl<$Res, SnapSetting>;
  @useResult
  $Res call(
      {@JsonKey(name: 'core') Core? core,
      @JsonKey(name: 'lenses') Lenses? lenses,
      @JsonKey(name: 'settings') Settings? settings});

  $CoreCopyWith<$Res>? get core;
  $LensesCopyWith<$Res>? get lenses;
  $SettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$SnapSettingCopyWithImpl<$Res, $Val extends SnapSetting>
    implements $SnapSettingCopyWith<$Res> {
  _$SnapSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? core = freezed,
    Object? lenses = freezed,
    Object? settings = freezed,
  }) {
    return _then(_value.copyWith(
      core: freezed == core
          ? _value.core
          : core // ignore: cast_nullable_to_non_nullable
              as Core?,
      lenses: freezed == lenses
          ? _value.lenses
          : lenses // ignore: cast_nullable_to_non_nullable
              as Lenses?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Settings?,
    ) as $Val);
  }

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoreCopyWith<$Res>? get core {
    if (_value.core == null) {
      return null;
    }

    return $CoreCopyWith<$Res>(_value.core!, (value) {
      return _then(_value.copyWith(core: value) as $Val);
    });
  }

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LensesCopyWith<$Res>? get lenses {
    if (_value.lenses == null) {
      return null;
    }

    return $LensesCopyWith<$Res>(_value.lenses!, (value) {
      return _then(_value.copyWith(lenses: value) as $Val);
    });
  }

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $SettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SnapSettingImplCopyWith<$Res>
    implements $SnapSettingCopyWith<$Res> {
  factory _$$SnapSettingImplCopyWith(
          _$SnapSettingImpl value, $Res Function(_$SnapSettingImpl) then) =
      __$$SnapSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'core') Core? core,
      @JsonKey(name: 'lenses') Lenses? lenses,
      @JsonKey(name: 'settings') Settings? settings});

  @override
  $CoreCopyWith<$Res>? get core;
  @override
  $LensesCopyWith<$Res>? get lenses;
  @override
  $SettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$SnapSettingImplCopyWithImpl<$Res>
    extends _$SnapSettingCopyWithImpl<$Res, _$SnapSettingImpl>
    implements _$$SnapSettingImplCopyWith<$Res> {
  __$$SnapSettingImplCopyWithImpl(
      _$SnapSettingImpl _value, $Res Function(_$SnapSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? core = freezed,
    Object? lenses = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$SnapSettingImpl(
      core: freezed == core
          ? _value.core
          : core // ignore: cast_nullable_to_non_nullable
              as Core?,
      lenses: freezed == lenses
          ? _value.lenses
          : lenses // ignore: cast_nullable_to_non_nullable
              as Lenses?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Settings?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SnapSettingImpl implements _SnapSetting {
  const _$SnapSettingImpl(
      {@JsonKey(name: 'core') this.core,
      @JsonKey(name: 'lenses') this.lenses,
      @JsonKey(name: 'settings') this.settings});

  factory _$SnapSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SnapSettingImplFromJson(json);

  @override
  @JsonKey(name: 'core')
  final Core? core;
  @override
  @JsonKey(name: 'lenses')
  final Lenses? lenses;
  @override
  @JsonKey(name: 'settings')
  final Settings? settings;

  @override
  String toString() {
    return 'SnapSetting(core: $core, lenses: $lenses, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnapSettingImpl &&
            (identical(other.core, core) || other.core == core) &&
            (identical(other.lenses, lenses) || other.lenses == lenses) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, core, lenses, settings);

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnapSettingImplCopyWith<_$SnapSettingImpl> get copyWith =>
      __$$SnapSettingImplCopyWithImpl<_$SnapSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SnapSettingImplToJson(
      this,
    );
  }
}

abstract class _SnapSetting implements SnapSetting {
  const factory _SnapSetting(
      {@JsonKey(name: 'core') final Core? core,
      @JsonKey(name: 'lenses') final Lenses? lenses,
      @JsonKey(name: 'settings') final Settings? settings}) = _$SnapSettingImpl;

  factory _SnapSetting.fromJson(Map<String, dynamic> json) =
      _$SnapSettingImpl.fromJson;

  @override
  @JsonKey(name: 'core')
  Core? get core;
  @override
  @JsonKey(name: 'lenses')
  Lenses? get lenses;
  @override
  @JsonKey(name: 'settings')
  Settings? get settings;

  /// Create a copy of SnapSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnapSettingImplCopyWith<_$SnapSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return _Settings.fromJson(json);
}

/// @nodoc
mixin _$Settings {
  @JsonKey(name: 'always_show_snapcode')
  bool? get alwaysShowSnapcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'automatic_updates')
  bool? get automaticUpdates => throw _privateConstructorUsedError;
  @JsonKey(name: 'launch_on_startup')
  bool? get launchOnStartup => throw _privateConstructorUsedError;
  @JsonKey(name: 'mirror_preview')
  bool? get mirrorPreview => throw _privateConstructorUsedError;
  @JsonKey(name: 'recorder_unused')
  bool? get recorderUnused => throw _privateConstructorUsedError;
  @JsonKey(name: 'shortcuts')
  Shortcuts? get shortcuts => throw _privateConstructorUsedError;
  @JsonKey(name: 'should_show_make_call_hint')
  bool? get shouldShowMakeCallHint => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_onboarding')
  bool? get showOnboarding => throw _privateConstructorUsedError;
  @JsonKey(name: 'skip_version')
  SkipVersion? get skipVersion => throw _privateConstructorUsedError;

  /// Serializes this Settings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res, Settings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'always_show_snapcode') bool? alwaysShowSnapcode,
      @JsonKey(name: 'automatic_updates') bool? automaticUpdates,
      @JsonKey(name: 'launch_on_startup') bool? launchOnStartup,
      @JsonKey(name: 'mirror_preview') bool? mirrorPreview,
      @JsonKey(name: 'recorder_unused') bool? recorderUnused,
      @JsonKey(name: 'shortcuts') Shortcuts? shortcuts,
      @JsonKey(name: 'should_show_make_call_hint') bool? shouldShowMakeCallHint,
      @JsonKey(name: 'show_onboarding') bool? showOnboarding,
      @JsonKey(name: 'skip_version') SkipVersion? skipVersion});

  $ShortcutsCopyWith<$Res>? get shortcuts;
  $SkipVersionCopyWith<$Res>? get skipVersion;
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res, $Val extends Settings>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alwaysShowSnapcode = freezed,
    Object? automaticUpdates = freezed,
    Object? launchOnStartup = freezed,
    Object? mirrorPreview = freezed,
    Object? recorderUnused = freezed,
    Object? shortcuts = freezed,
    Object? shouldShowMakeCallHint = freezed,
    Object? showOnboarding = freezed,
    Object? skipVersion = freezed,
  }) {
    return _then(_value.copyWith(
      alwaysShowSnapcode: freezed == alwaysShowSnapcode
          ? _value.alwaysShowSnapcode
          : alwaysShowSnapcode // ignore: cast_nullable_to_non_nullable
              as bool?,
      automaticUpdates: freezed == automaticUpdates
          ? _value.automaticUpdates
          : automaticUpdates // ignore: cast_nullable_to_non_nullable
              as bool?,
      launchOnStartup: freezed == launchOnStartup
          ? _value.launchOnStartup
          : launchOnStartup // ignore: cast_nullable_to_non_nullable
              as bool?,
      mirrorPreview: freezed == mirrorPreview
          ? _value.mirrorPreview
          : mirrorPreview // ignore: cast_nullable_to_non_nullable
              as bool?,
      recorderUnused: freezed == recorderUnused
          ? _value.recorderUnused
          : recorderUnused // ignore: cast_nullable_to_non_nullable
              as bool?,
      shortcuts: freezed == shortcuts
          ? _value.shortcuts
          : shortcuts // ignore: cast_nullable_to_non_nullable
              as Shortcuts?,
      shouldShowMakeCallHint: freezed == shouldShowMakeCallHint
          ? _value.shouldShowMakeCallHint
          : shouldShowMakeCallHint // ignore: cast_nullable_to_non_nullable
              as bool?,
      showOnboarding: freezed == showOnboarding
          ? _value.showOnboarding
          : showOnboarding // ignore: cast_nullable_to_non_nullable
              as bool?,
      skipVersion: freezed == skipVersion
          ? _value.skipVersion
          : skipVersion // ignore: cast_nullable_to_non_nullable
              as SkipVersion?,
    ) as $Val);
  }

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShortcutsCopyWith<$Res>? get shortcuts {
    if (_value.shortcuts == null) {
      return null;
    }

    return $ShortcutsCopyWith<$Res>(_value.shortcuts!, (value) {
      return _then(_value.copyWith(shortcuts: value) as $Val);
    });
  }

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SkipVersionCopyWith<$Res>? get skipVersion {
    if (_value.skipVersion == null) {
      return null;
    }

    return $SkipVersionCopyWith<$Res>(_value.skipVersion!, (value) {
      return _then(_value.copyWith(skipVersion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsImplCopyWith<$Res>
    implements $SettingsCopyWith<$Res> {
  factory _$$SettingsImplCopyWith(
          _$SettingsImpl value, $Res Function(_$SettingsImpl) then) =
      __$$SettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'always_show_snapcode') bool? alwaysShowSnapcode,
      @JsonKey(name: 'automatic_updates') bool? automaticUpdates,
      @JsonKey(name: 'launch_on_startup') bool? launchOnStartup,
      @JsonKey(name: 'mirror_preview') bool? mirrorPreview,
      @JsonKey(name: 'recorder_unused') bool? recorderUnused,
      @JsonKey(name: 'shortcuts') Shortcuts? shortcuts,
      @JsonKey(name: 'should_show_make_call_hint') bool? shouldShowMakeCallHint,
      @JsonKey(name: 'show_onboarding') bool? showOnboarding,
      @JsonKey(name: 'skip_version') SkipVersion? skipVersion});

  @override
  $ShortcutsCopyWith<$Res>? get shortcuts;
  @override
  $SkipVersionCopyWith<$Res>? get skipVersion;
}

/// @nodoc
class __$$SettingsImplCopyWithImpl<$Res>
    extends _$SettingsCopyWithImpl<$Res, _$SettingsImpl>
    implements _$$SettingsImplCopyWith<$Res> {
  __$$SettingsImplCopyWithImpl(
      _$SettingsImpl _value, $Res Function(_$SettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alwaysShowSnapcode = freezed,
    Object? automaticUpdates = freezed,
    Object? launchOnStartup = freezed,
    Object? mirrorPreview = freezed,
    Object? recorderUnused = freezed,
    Object? shortcuts = freezed,
    Object? shouldShowMakeCallHint = freezed,
    Object? showOnboarding = freezed,
    Object? skipVersion = freezed,
  }) {
    return _then(_$SettingsImpl(
      alwaysShowSnapcode: freezed == alwaysShowSnapcode
          ? _value.alwaysShowSnapcode
          : alwaysShowSnapcode // ignore: cast_nullable_to_non_nullable
              as bool?,
      automaticUpdates: freezed == automaticUpdates
          ? _value.automaticUpdates
          : automaticUpdates // ignore: cast_nullable_to_non_nullable
              as bool?,
      launchOnStartup: freezed == launchOnStartup
          ? _value.launchOnStartup
          : launchOnStartup // ignore: cast_nullable_to_non_nullable
              as bool?,
      mirrorPreview: freezed == mirrorPreview
          ? _value.mirrorPreview
          : mirrorPreview // ignore: cast_nullable_to_non_nullable
              as bool?,
      recorderUnused: freezed == recorderUnused
          ? _value.recorderUnused
          : recorderUnused // ignore: cast_nullable_to_non_nullable
              as bool?,
      shortcuts: freezed == shortcuts
          ? _value.shortcuts
          : shortcuts // ignore: cast_nullable_to_non_nullable
              as Shortcuts?,
      shouldShowMakeCallHint: freezed == shouldShowMakeCallHint
          ? _value.shouldShowMakeCallHint
          : shouldShowMakeCallHint // ignore: cast_nullable_to_non_nullable
              as bool?,
      showOnboarding: freezed == showOnboarding
          ? _value.showOnboarding
          : showOnboarding // ignore: cast_nullable_to_non_nullable
              as bool?,
      skipVersion: freezed == skipVersion
          ? _value.skipVersion
          : skipVersion // ignore: cast_nullable_to_non_nullable
              as SkipVersion?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsImpl implements _Settings {
  const _$SettingsImpl(
      {@JsonKey(name: 'always_show_snapcode') this.alwaysShowSnapcode,
      @JsonKey(name: 'automatic_updates') this.automaticUpdates,
      @JsonKey(name: 'launch_on_startup') this.launchOnStartup,
      @JsonKey(name: 'mirror_preview') this.mirrorPreview,
      @JsonKey(name: 'recorder_unused') this.recorderUnused,
      @JsonKey(name: 'shortcuts') this.shortcuts,
      @JsonKey(name: 'should_show_make_call_hint') this.shouldShowMakeCallHint,
      @JsonKey(name: 'show_onboarding') this.showOnboarding,
      @JsonKey(name: 'skip_version') this.skipVersion});

  factory _$SettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsImplFromJson(json);

  @override
  @JsonKey(name: 'always_show_snapcode')
  final bool? alwaysShowSnapcode;
  @override
  @JsonKey(name: 'automatic_updates')
  final bool? automaticUpdates;
  @override
  @JsonKey(name: 'launch_on_startup')
  final bool? launchOnStartup;
  @override
  @JsonKey(name: 'mirror_preview')
  final bool? mirrorPreview;
  @override
  @JsonKey(name: 'recorder_unused')
  final bool? recorderUnused;
  @override
  @JsonKey(name: 'shortcuts')
  final Shortcuts? shortcuts;
  @override
  @JsonKey(name: 'should_show_make_call_hint')
  final bool? shouldShowMakeCallHint;
  @override
  @JsonKey(name: 'show_onboarding')
  final bool? showOnboarding;
  @override
  @JsonKey(name: 'skip_version')
  final SkipVersion? skipVersion;

  @override
  String toString() {
    return 'Settings(alwaysShowSnapcode: $alwaysShowSnapcode, automaticUpdates: $automaticUpdates, launchOnStartup: $launchOnStartup, mirrorPreview: $mirrorPreview, recorderUnused: $recorderUnused, shortcuts: $shortcuts, shouldShowMakeCallHint: $shouldShowMakeCallHint, showOnboarding: $showOnboarding, skipVersion: $skipVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsImpl &&
            (identical(other.alwaysShowSnapcode, alwaysShowSnapcode) ||
                other.alwaysShowSnapcode == alwaysShowSnapcode) &&
            (identical(other.automaticUpdates, automaticUpdates) ||
                other.automaticUpdates == automaticUpdates) &&
            (identical(other.launchOnStartup, launchOnStartup) ||
                other.launchOnStartup == launchOnStartup) &&
            (identical(other.mirrorPreview, mirrorPreview) ||
                other.mirrorPreview == mirrorPreview) &&
            (identical(other.recorderUnused, recorderUnused) ||
                other.recorderUnused == recorderUnused) &&
            (identical(other.shortcuts, shortcuts) ||
                other.shortcuts == shortcuts) &&
            (identical(other.shouldShowMakeCallHint, shouldShowMakeCallHint) ||
                other.shouldShowMakeCallHint == shouldShowMakeCallHint) &&
            (identical(other.showOnboarding, showOnboarding) ||
                other.showOnboarding == showOnboarding) &&
            (identical(other.skipVersion, skipVersion) ||
                other.skipVersion == skipVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      alwaysShowSnapcode,
      automaticUpdates,
      launchOnStartup,
      mirrorPreview,
      recorderUnused,
      shortcuts,
      shouldShowMakeCallHint,
      showOnboarding,
      skipVersion);

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      __$$SettingsImplCopyWithImpl<_$SettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsImplToJson(
      this,
    );
  }
}

abstract class _Settings implements Settings {
  const factory _Settings(
      {@JsonKey(name: 'always_show_snapcode') final bool? alwaysShowSnapcode,
      @JsonKey(name: 'automatic_updates') final bool? automaticUpdates,
      @JsonKey(name: 'launch_on_startup') final bool? launchOnStartup,
      @JsonKey(name: 'mirror_preview') final bool? mirrorPreview,
      @JsonKey(name: 'recorder_unused') final bool? recorderUnused,
      @JsonKey(name: 'shortcuts') final Shortcuts? shortcuts,
      @JsonKey(name: 'should_show_make_call_hint')
      final bool? shouldShowMakeCallHint,
      @JsonKey(name: 'show_onboarding') final bool? showOnboarding,
      @JsonKey(name: 'skip_version')
      final SkipVersion? skipVersion}) = _$SettingsImpl;

  factory _Settings.fromJson(Map<String, dynamic> json) =
      _$SettingsImpl.fromJson;

  @override
  @JsonKey(name: 'always_show_snapcode')
  bool? get alwaysShowSnapcode;
  @override
  @JsonKey(name: 'automatic_updates')
  bool? get automaticUpdates;
  @override
  @JsonKey(name: 'launch_on_startup')
  bool? get launchOnStartup;
  @override
  @JsonKey(name: 'mirror_preview')
  bool? get mirrorPreview;
  @override
  @JsonKey(name: 'recorder_unused')
  bool? get recorderUnused;
  @override
  @JsonKey(name: 'shortcuts')
  Shortcuts? get shortcuts;
  @override
  @JsonKey(name: 'should_show_make_call_hint')
  bool? get shouldShowMakeCallHint;
  @override
  @JsonKey(name: 'show_onboarding')
  bool? get showOnboarding;
  @override
  @JsonKey(name: 'skip_version')
  SkipVersion? get skipVersion;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkipVersion _$SkipVersionFromJson(Map<String, dynamic> json) {
  return _SkipVersion.fromJson(json);
}

/// @nodoc
mixin _$SkipVersion {
  @JsonKey(name: 'build')
  int? get build => throw _privateConstructorUsedError;
  @JsonKey(name: 'major')
  int? get major => throw _privateConstructorUsedError;
  @JsonKey(name: 'minor')
  int? get minor => throw _privateConstructorUsedError;
  @JsonKey(name: 'patch')
  int? get patch => throw _privateConstructorUsedError;

  /// Serializes this SkipVersion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkipVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkipVersionCopyWith<SkipVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkipVersionCopyWith<$Res> {
  factory $SkipVersionCopyWith(
          SkipVersion value, $Res Function(SkipVersion) then) =
      _$SkipVersionCopyWithImpl<$Res, SkipVersion>;
  @useResult
  $Res call(
      {@JsonKey(name: 'build') int? build,
      @JsonKey(name: 'major') int? major,
      @JsonKey(name: 'minor') int? minor,
      @JsonKey(name: 'patch') int? patch});
}

/// @nodoc
class _$SkipVersionCopyWithImpl<$Res, $Val extends SkipVersion>
    implements $SkipVersionCopyWith<$Res> {
  _$SkipVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkipVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? build = freezed,
    Object? major = freezed,
    Object? minor = freezed,
    Object? patch = freezed,
  }) {
    return _then(_value.copyWith(
      build: freezed == build
          ? _value.build
          : build // ignore: cast_nullable_to_non_nullable
              as int?,
      major: freezed == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as int?,
      minor: freezed == minor
          ? _value.minor
          : minor // ignore: cast_nullable_to_non_nullable
              as int?,
      patch: freezed == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkipVersionImplCopyWith<$Res>
    implements $SkipVersionCopyWith<$Res> {
  factory _$$SkipVersionImplCopyWith(
          _$SkipVersionImpl value, $Res Function(_$SkipVersionImpl) then) =
      __$$SkipVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'build') int? build,
      @JsonKey(name: 'major') int? major,
      @JsonKey(name: 'minor') int? minor,
      @JsonKey(name: 'patch') int? patch});
}

/// @nodoc
class __$$SkipVersionImplCopyWithImpl<$Res>
    extends _$SkipVersionCopyWithImpl<$Res, _$SkipVersionImpl>
    implements _$$SkipVersionImplCopyWith<$Res> {
  __$$SkipVersionImplCopyWithImpl(
      _$SkipVersionImpl _value, $Res Function(_$SkipVersionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkipVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? build = freezed,
    Object? major = freezed,
    Object? minor = freezed,
    Object? patch = freezed,
  }) {
    return _then(_$SkipVersionImpl(
      build: freezed == build
          ? _value.build
          : build // ignore: cast_nullable_to_non_nullable
              as int?,
      major: freezed == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as int?,
      minor: freezed == minor
          ? _value.minor
          : minor // ignore: cast_nullable_to_non_nullable
              as int?,
      patch: freezed == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkipVersionImpl implements _SkipVersion {
  const _$SkipVersionImpl(
      {@JsonKey(name: 'build') this.build,
      @JsonKey(name: 'major') this.major,
      @JsonKey(name: 'minor') this.minor,
      @JsonKey(name: 'patch') this.patch});

  factory _$SkipVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkipVersionImplFromJson(json);

  @override
  @JsonKey(name: 'build')
  final int? build;
  @override
  @JsonKey(name: 'major')
  final int? major;
  @override
  @JsonKey(name: 'minor')
  final int? minor;
  @override
  @JsonKey(name: 'patch')
  final int? patch;

  @override
  String toString() {
    return 'SkipVersion(build: $build, major: $major, minor: $minor, patch: $patch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkipVersionImpl &&
            (identical(other.build, build) || other.build == build) &&
            (identical(other.major, major) || other.major == major) &&
            (identical(other.minor, minor) || other.minor == minor) &&
            (identical(other.patch, patch) || other.patch == patch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, build, major, minor, patch);

  /// Create a copy of SkipVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkipVersionImplCopyWith<_$SkipVersionImpl> get copyWith =>
      __$$SkipVersionImplCopyWithImpl<_$SkipVersionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkipVersionImplToJson(
      this,
    );
  }
}

abstract class _SkipVersion implements SkipVersion {
  const factory _SkipVersion(
      {@JsonKey(name: 'build') final int? build,
      @JsonKey(name: 'major') final int? major,
      @JsonKey(name: 'minor') final int? minor,
      @JsonKey(name: 'patch') final int? patch}) = _$SkipVersionImpl;

  factory _SkipVersion.fromJson(Map<String, dynamic> json) =
      _$SkipVersionImpl.fromJson;

  @override
  @JsonKey(name: 'build')
  int? get build;
  @override
  @JsonKey(name: 'major')
  int? get major;
  @override
  @JsonKey(name: 'minor')
  int? get minor;
  @override
  @JsonKey(name: 'patch')
  int? get patch;

  /// Create a copy of SkipVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkipVersionImplCopyWith<_$SkipVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Shortcuts _$ShortcutsFromJson(Map<String, dynamic> json) {
  return _Shortcuts.fromJson(json);
}

/// @nodoc
mixin _$Shortcuts {
  @JsonKey(name: 'lenses_shortcuts')
  List<LensesShortcuts>? get lensesShortcuts =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'role_shortcuts')
  dynamic get roleShortcuts => throw _privateConstructorUsedError;

  /// Serializes this Shortcuts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shortcuts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShortcutsCopyWith<Shortcuts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShortcutsCopyWith<$Res> {
  factory $ShortcutsCopyWith(Shortcuts value, $Res Function(Shortcuts) then) =
      _$ShortcutsCopyWithImpl<$Res, Shortcuts>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lenses_shortcuts')
      List<LensesShortcuts>? lensesShortcuts,
      @JsonKey(name: 'role_shortcuts') dynamic roleShortcuts});
}

/// @nodoc
class _$ShortcutsCopyWithImpl<$Res, $Val extends Shortcuts>
    implements $ShortcutsCopyWith<$Res> {
  _$ShortcutsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shortcuts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensesShortcuts = freezed,
    Object? roleShortcuts = freezed,
  }) {
    return _then(_value.copyWith(
      lensesShortcuts: freezed == lensesShortcuts
          ? _value.lensesShortcuts
          : lensesShortcuts // ignore: cast_nullable_to_non_nullable
              as List<LensesShortcuts>?,
      roleShortcuts: freezed == roleShortcuts
          ? _value.roleShortcuts
          : roleShortcuts // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShortcutsImplCopyWith<$Res>
    implements $ShortcutsCopyWith<$Res> {
  factory _$$ShortcutsImplCopyWith(
          _$ShortcutsImpl value, $Res Function(_$ShortcutsImpl) then) =
      __$$ShortcutsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lenses_shortcuts')
      List<LensesShortcuts>? lensesShortcuts,
      @JsonKey(name: 'role_shortcuts') dynamic roleShortcuts});
}

/// @nodoc
class __$$ShortcutsImplCopyWithImpl<$Res>
    extends _$ShortcutsCopyWithImpl<$Res, _$ShortcutsImpl>
    implements _$$ShortcutsImplCopyWith<$Res> {
  __$$ShortcutsImplCopyWithImpl(
      _$ShortcutsImpl _value, $Res Function(_$ShortcutsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Shortcuts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensesShortcuts = freezed,
    Object? roleShortcuts = freezed,
  }) {
    return _then(_$ShortcutsImpl(
      lensesShortcuts: freezed == lensesShortcuts
          ? _value._lensesShortcuts
          : lensesShortcuts // ignore: cast_nullable_to_non_nullable
              as List<LensesShortcuts>?,
      roleShortcuts: freezed == roleShortcuts
          ? _value.roleShortcuts
          : roleShortcuts // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShortcutsImpl implements _Shortcuts {
  const _$ShortcutsImpl(
      {@JsonKey(name: 'lenses_shortcuts')
      final List<LensesShortcuts>? lensesShortcuts,
      @JsonKey(name: 'role_shortcuts') this.roleShortcuts})
      : _lensesShortcuts = lensesShortcuts;

  factory _$ShortcutsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortcutsImplFromJson(json);

  final List<LensesShortcuts>? _lensesShortcuts;
  @override
  @JsonKey(name: 'lenses_shortcuts')
  List<LensesShortcuts>? get lensesShortcuts {
    final value = _lensesShortcuts;
    if (value == null) return null;
    if (_lensesShortcuts is EqualUnmodifiableListView) return _lensesShortcuts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'role_shortcuts')
  final dynamic roleShortcuts;

  @override
  String toString() {
    return 'Shortcuts(lensesShortcuts: $lensesShortcuts, roleShortcuts: $roleShortcuts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortcutsImpl &&
            const DeepCollectionEquality()
                .equals(other._lensesShortcuts, _lensesShortcuts) &&
            const DeepCollectionEquality()
                .equals(other.roleShortcuts, roleShortcuts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_lensesShortcuts),
      const DeepCollectionEquality().hash(roleShortcuts));

  /// Create a copy of Shortcuts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortcutsImplCopyWith<_$ShortcutsImpl> get copyWith =>
      __$$ShortcutsImplCopyWithImpl<_$ShortcutsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortcutsImplToJson(
      this,
    );
  }
}

abstract class _Shortcuts implements Shortcuts {
  const factory _Shortcuts(
          {@JsonKey(name: 'lenses_shortcuts')
          final List<LensesShortcuts>? lensesShortcuts,
          @JsonKey(name: 'role_shortcuts') final dynamic roleShortcuts}) =
      _$ShortcutsImpl;

  factory _Shortcuts.fromJson(Map<String, dynamic> json) =
      _$ShortcutsImpl.fromJson;

  @override
  @JsonKey(name: 'lenses_shortcuts')
  List<LensesShortcuts>? get lensesShortcuts;
  @override
  @JsonKey(name: 'role_shortcuts')
  dynamic get roleShortcuts;

  /// Create a copy of Shortcuts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShortcutsImplCopyWith<_$ShortcutsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LensesShortcuts _$LensesShortcutsFromJson(Map<String, dynamic> json) {
  return _LensesShortcuts.fromJson(json);
}

/// @nodoc
mixin _$LensesShortcuts {
  @JsonKey(name: 'lens_id')
  String? get lensId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shortcut')
  String? get shortcut => throw _privateConstructorUsedError;

  /// Serializes this LensesShortcuts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensesShortcuts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensesShortcutsCopyWith<LensesShortcuts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensesShortcutsCopyWith<$Res> {
  factory $LensesShortcutsCopyWith(
          LensesShortcuts value, $Res Function(LensesShortcuts) then) =
      _$LensesShortcutsCopyWithImpl<$Res, LensesShortcuts>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lens_id') String? lensId,
      @JsonKey(name: 'shortcut') String? shortcut});
}

/// @nodoc
class _$LensesShortcutsCopyWithImpl<$Res, $Val extends LensesShortcuts>
    implements $LensesShortcutsCopyWith<$Res> {
  _$LensesShortcutsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensesShortcuts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensId = freezed,
    Object? shortcut = freezed,
  }) {
    return _then(_value.copyWith(
      lensId: freezed == lensId
          ? _value.lensId
          : lensId // ignore: cast_nullable_to_non_nullable
              as String?,
      shortcut: freezed == shortcut
          ? _value.shortcut
          : shortcut // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LensesShortcutsImplCopyWith<$Res>
    implements $LensesShortcutsCopyWith<$Res> {
  factory _$$LensesShortcutsImplCopyWith(_$LensesShortcutsImpl value,
          $Res Function(_$LensesShortcutsImpl) then) =
      __$$LensesShortcutsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lens_id') String? lensId,
      @JsonKey(name: 'shortcut') String? shortcut});
}

/// @nodoc
class __$$LensesShortcutsImplCopyWithImpl<$Res>
    extends _$LensesShortcutsCopyWithImpl<$Res, _$LensesShortcutsImpl>
    implements _$$LensesShortcutsImplCopyWith<$Res> {
  __$$LensesShortcutsImplCopyWithImpl(
      _$LensesShortcutsImpl _value, $Res Function(_$LensesShortcutsImpl) _then)
      : super(_value, _then);

  /// Create a copy of LensesShortcuts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensId = freezed,
    Object? shortcut = freezed,
  }) {
    return _then(_$LensesShortcutsImpl(
      lensId: freezed == lensId
          ? _value.lensId
          : lensId // ignore: cast_nullable_to_non_nullable
              as String?,
      shortcut: freezed == shortcut
          ? _value.shortcut
          : shortcut // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LensesShortcutsImpl implements _LensesShortcuts {
  const _$LensesShortcutsImpl(
      {@JsonKey(name: 'lens_id') this.lensId,
      @JsonKey(name: 'shortcut') this.shortcut});

  factory _$LensesShortcutsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensesShortcutsImplFromJson(json);

  @override
  @JsonKey(name: 'lens_id')
  final String? lensId;
  @override
  @JsonKey(name: 'shortcut')
  final String? shortcut;

  @override
  String toString() {
    return 'LensesShortcuts(lensId: $lensId, shortcut: $shortcut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensesShortcutsImpl &&
            (identical(other.lensId, lensId) || other.lensId == lensId) &&
            (identical(other.shortcut, shortcut) ||
                other.shortcut == shortcut));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lensId, shortcut);

  /// Create a copy of LensesShortcuts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensesShortcutsImplCopyWith<_$LensesShortcutsImpl> get copyWith =>
      __$$LensesShortcutsImplCopyWithImpl<_$LensesShortcutsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LensesShortcutsImplToJson(
      this,
    );
  }
}

abstract class _LensesShortcuts implements LensesShortcuts {
  const factory _LensesShortcuts(
          {@JsonKey(name: 'lens_id') final String? lensId,
          @JsonKey(name: 'shortcut') final String? shortcut}) =
      _$LensesShortcutsImpl;

  factory _LensesShortcuts.fromJson(Map<String, dynamic> json) =
      _$LensesShortcutsImpl.fromJson;

  @override
  @JsonKey(name: 'lens_id')
  String? get lensId;
  @override
  @JsonKey(name: 'shortcut')
  String? get shortcut;

  /// Create a copy of LensesShortcuts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensesShortcutsImplCopyWith<_$LensesShortcutsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Lenses _$LensesFromJson(Map<String, dynamic> json) {
  return _Lenses.fromJson(json);
}

/// @nodoc
mixin _$Lenses {
  @JsonKey(name: 'apply_first_scheduled')
  bool? get applyFirstScheduled => throw _privateConstructorUsedError;
  @JsonKey(name: 'cache')
  Cache? get cache => throw _privateConstructorUsedError;
  @JsonKey(name: 'favorites')
  List<String>? get favorites => throw _privateConstructorUsedError;
  @JsonKey(name: 'recents')
  List<Recents>? get recents => throw _privateConstructorUsedError;
  @JsonKey(name: 'retouch')
  bool? get retouch => throw _privateConstructorUsedError;

  /// Serializes this Lenses to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lenses
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensesCopyWith<Lenses> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensesCopyWith<$Res> {
  factory $LensesCopyWith(Lenses value, $Res Function(Lenses) then) =
      _$LensesCopyWithImpl<$Res, Lenses>;
  @useResult
  $Res call(
      {@JsonKey(name: 'apply_first_scheduled') bool? applyFirstScheduled,
      @JsonKey(name: 'cache') Cache? cache,
      @JsonKey(name: 'favorites') List<String>? favorites,
      @JsonKey(name: 'recents') List<Recents>? recents,
      @JsonKey(name: 'retouch') bool? retouch});

  $CacheCopyWith<$Res>? get cache;
}

/// @nodoc
class _$LensesCopyWithImpl<$Res, $Val extends Lenses>
    implements $LensesCopyWith<$Res> {
  _$LensesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lenses
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applyFirstScheduled = freezed,
    Object? cache = freezed,
    Object? favorites = freezed,
    Object? recents = freezed,
    Object? retouch = freezed,
  }) {
    return _then(_value.copyWith(
      applyFirstScheduled: freezed == applyFirstScheduled
          ? _value.applyFirstScheduled
          : applyFirstScheduled // ignore: cast_nullable_to_non_nullable
              as bool?,
      cache: freezed == cache
          ? _value.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as Cache?,
      favorites: freezed == favorites
          ? _value.favorites
          : favorites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recents: freezed == recents
          ? _value.recents
          : recents // ignore: cast_nullable_to_non_nullable
              as List<Recents>?,
      retouch: freezed == retouch
          ? _value.retouch
          : retouch // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of Lenses
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CacheCopyWith<$Res>? get cache {
    if (_value.cache == null) {
      return null;
    }

    return $CacheCopyWith<$Res>(_value.cache!, (value) {
      return _then(_value.copyWith(cache: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LensesImplCopyWith<$Res> implements $LensesCopyWith<$Res> {
  factory _$$LensesImplCopyWith(
          _$LensesImpl value, $Res Function(_$LensesImpl) then) =
      __$$LensesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'apply_first_scheduled') bool? applyFirstScheduled,
      @JsonKey(name: 'cache') Cache? cache,
      @JsonKey(name: 'favorites') List<String>? favorites,
      @JsonKey(name: 'recents') List<Recents>? recents,
      @JsonKey(name: 'retouch') bool? retouch});

  @override
  $CacheCopyWith<$Res>? get cache;
}

/// @nodoc
class __$$LensesImplCopyWithImpl<$Res>
    extends _$LensesCopyWithImpl<$Res, _$LensesImpl>
    implements _$$LensesImplCopyWith<$Res> {
  __$$LensesImplCopyWithImpl(
      _$LensesImpl _value, $Res Function(_$LensesImpl) _then)
      : super(_value, _then);

  /// Create a copy of Lenses
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applyFirstScheduled = freezed,
    Object? cache = freezed,
    Object? favorites = freezed,
    Object? recents = freezed,
    Object? retouch = freezed,
  }) {
    return _then(_$LensesImpl(
      applyFirstScheduled: freezed == applyFirstScheduled
          ? _value.applyFirstScheduled
          : applyFirstScheduled // ignore: cast_nullable_to_non_nullable
              as bool?,
      cache: freezed == cache
          ? _value.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as Cache?,
      favorites: freezed == favorites
          ? _value._favorites
          : favorites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recents: freezed == recents
          ? _value._recents
          : recents // ignore: cast_nullable_to_non_nullable
              as List<Recents>?,
      retouch: freezed == retouch
          ? _value.retouch
          : retouch // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LensesImpl implements _Lenses {
  const _$LensesImpl(
      {@JsonKey(name: 'apply_first_scheduled') this.applyFirstScheduled,
      @JsonKey(name: 'cache') this.cache,
      @JsonKey(name: 'favorites') final List<String>? favorites,
      @JsonKey(name: 'recents') final List<Recents>? recents,
      @JsonKey(name: 'retouch') this.retouch})
      : _favorites = favorites,
        _recents = recents;

  factory _$LensesImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensesImplFromJson(json);

  @override
  @JsonKey(name: 'apply_first_scheduled')
  final bool? applyFirstScheduled;
  @override
  @JsonKey(name: 'cache')
  final Cache? cache;
  final List<String>? _favorites;
  @override
  @JsonKey(name: 'favorites')
  List<String>? get favorites {
    final value = _favorites;
    if (value == null) return null;
    if (_favorites is EqualUnmodifiableListView) return _favorites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Recents>? _recents;
  @override
  @JsonKey(name: 'recents')
  List<Recents>? get recents {
    final value = _recents;
    if (value == null) return null;
    if (_recents is EqualUnmodifiableListView) return _recents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'retouch')
  final bool? retouch;

  @override
  String toString() {
    return 'Lenses(applyFirstScheduled: $applyFirstScheduled, cache: $cache, favorites: $favorites, recents: $recents, retouch: $retouch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensesImpl &&
            (identical(other.applyFirstScheduled, applyFirstScheduled) ||
                other.applyFirstScheduled == applyFirstScheduled) &&
            (identical(other.cache, cache) || other.cache == cache) &&
            const DeepCollectionEquality()
                .equals(other._favorites, _favorites) &&
            const DeepCollectionEquality().equals(other._recents, _recents) &&
            (identical(other.retouch, retouch) || other.retouch == retouch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      applyFirstScheduled,
      cache,
      const DeepCollectionEquality().hash(_favorites),
      const DeepCollectionEquality().hash(_recents),
      retouch);

  /// Create a copy of Lenses
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensesImplCopyWith<_$LensesImpl> get copyWith =>
      __$$LensesImplCopyWithImpl<_$LensesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LensesImplToJson(
      this,
    );
  }
}

abstract class _Lenses implements Lenses {
  const factory _Lenses(
      {@JsonKey(name: 'apply_first_scheduled') final bool? applyFirstScheduled,
      @JsonKey(name: 'cache') final Cache? cache,
      @JsonKey(name: 'favorites') final List<String>? favorites,
      @JsonKey(name: 'recents') final List<Recents>? recents,
      @JsonKey(name: 'retouch') final bool? retouch}) = _$LensesImpl;

  factory _Lenses.fromJson(Map<String, dynamic> json) = _$LensesImpl.fromJson;

  @override
  @JsonKey(name: 'apply_first_scheduled')
  bool? get applyFirstScheduled;
  @override
  @JsonKey(name: 'cache')
  Cache? get cache;
  @override
  @JsonKey(name: 'favorites')
  List<String>? get favorites;
  @override
  @JsonKey(name: 'recents')
  List<Recents>? get recents;
  @override
  @JsonKey(name: 'retouch')
  bool? get retouch;

  /// Create a copy of Lenses
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensesImplCopyWith<_$LensesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Recents _$RecentsFromJson(Map<String, dynamic> json) {
  return _Recents.fromJson(json);
}

/// @nodoc
mixin _$Recents {
  @JsonKey(name: 'lensId')
  String? get lensId => throw _privateConstructorUsedError;
  @JsonKey(name: 'timestamp')
  int? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this Recents to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentsCopyWith<Recents> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentsCopyWith<$Res> {
  factory $RecentsCopyWith(Recents value, $Res Function(Recents) then) =
      _$RecentsCopyWithImpl<$Res, Recents>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lensId') String? lensId,
      @JsonKey(name: 'timestamp') int? timestamp});
}

/// @nodoc
class _$RecentsCopyWithImpl<$Res, $Val extends Recents>
    implements $RecentsCopyWith<$Res> {
  _$RecentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensId = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      lensId: freezed == lensId
          ? _value.lensId
          : lensId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentsImplCopyWith<$Res> implements $RecentsCopyWith<$Res> {
  factory _$$RecentsImplCopyWith(
          _$RecentsImpl value, $Res Function(_$RecentsImpl) then) =
      __$$RecentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lensId') String? lensId,
      @JsonKey(name: 'timestamp') int? timestamp});
}

/// @nodoc
class __$$RecentsImplCopyWithImpl<$Res>
    extends _$RecentsCopyWithImpl<$Res, _$RecentsImpl>
    implements _$$RecentsImplCopyWith<$Res> {
  __$$RecentsImplCopyWithImpl(
      _$RecentsImpl _value, $Res Function(_$RecentsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensId = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$RecentsImpl(
      lensId: freezed == lensId
          ? _value.lensId
          : lensId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentsImpl implements _Recents {
  const _$RecentsImpl(
      {@JsonKey(name: 'lensId') this.lensId,
      @JsonKey(name: 'timestamp') this.timestamp});

  factory _$RecentsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentsImplFromJson(json);

  @override
  @JsonKey(name: 'lensId')
  final String? lensId;
  @override
  @JsonKey(name: 'timestamp')
  final int? timestamp;

  @override
  String toString() {
    return 'Recents(lensId: $lensId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentsImpl &&
            (identical(other.lensId, lensId) || other.lensId == lensId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lensId, timestamp);

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentsImplCopyWith<_$RecentsImpl> get copyWith =>
      __$$RecentsImplCopyWithImpl<_$RecentsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentsImplToJson(
      this,
    );
  }
}

abstract class _Recents implements Recents {
  const factory _Recents(
      {@JsonKey(name: 'lensId') final String? lensId,
      @JsonKey(name: 'timestamp') final int? timestamp}) = _$RecentsImpl;

  factory _Recents.fromJson(Map<String, dynamic> json) = _$RecentsImpl.fromJson;

  @override
  @JsonKey(name: 'lensId')
  String? get lensId;
  @override
  @JsonKey(name: 'timestamp')
  int? get timestamp;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentsImplCopyWith<_$RecentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Cache _$CacheFromJson(Map<String, dynamic> json) {
  return _Cache.fromJson(json);
}

/// @nodoc
mixin _$Cache {
  @JsonKey(name: 'cachePath')
  String? get cachePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'cacheSize')
  int? get cacheSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'cacheVersion')
  int? get cacheVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'cachedInfo')
  List<CachedInfo>? get cachedInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'clearingQueue')
  List<String>? get clearingQueue => throw _privateConstructorUsedError;

  /// Serializes this Cache to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cache
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CacheCopyWith<Cache> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CacheCopyWith<$Res> {
  factory $CacheCopyWith(Cache value, $Res Function(Cache) then) =
      _$CacheCopyWithImpl<$Res, Cache>;
  @useResult
  $Res call(
      {@JsonKey(name: 'cachePath') String? cachePath,
      @JsonKey(name: 'cacheSize') int? cacheSize,
      @JsonKey(name: 'cacheVersion') int? cacheVersion,
      @JsonKey(name: 'cachedInfo') List<CachedInfo>? cachedInfo,
      @JsonKey(name: 'clearingQueue') List<String>? clearingQueue});
}

/// @nodoc
class _$CacheCopyWithImpl<$Res, $Val extends Cache>
    implements $CacheCopyWith<$Res> {
  _$CacheCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cache
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cachePath = freezed,
    Object? cacheSize = freezed,
    Object? cacheVersion = freezed,
    Object? cachedInfo = freezed,
    Object? clearingQueue = freezed,
  }) {
    return _then(_value.copyWith(
      cachePath: freezed == cachePath
          ? _value.cachePath
          : cachePath // ignore: cast_nullable_to_non_nullable
              as String?,
      cacheSize: freezed == cacheSize
          ? _value.cacheSize
          : cacheSize // ignore: cast_nullable_to_non_nullable
              as int?,
      cacheVersion: freezed == cacheVersion
          ? _value.cacheVersion
          : cacheVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      cachedInfo: freezed == cachedInfo
          ? _value.cachedInfo
          : cachedInfo // ignore: cast_nullable_to_non_nullable
              as List<CachedInfo>?,
      clearingQueue: freezed == clearingQueue
          ? _value.clearingQueue
          : clearingQueue // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CacheImplCopyWith<$Res> implements $CacheCopyWith<$Res> {
  factory _$$CacheImplCopyWith(
          _$CacheImpl value, $Res Function(_$CacheImpl) then) =
      __$$CacheImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'cachePath') String? cachePath,
      @JsonKey(name: 'cacheSize') int? cacheSize,
      @JsonKey(name: 'cacheVersion') int? cacheVersion,
      @JsonKey(name: 'cachedInfo') List<CachedInfo>? cachedInfo,
      @JsonKey(name: 'clearingQueue') List<String>? clearingQueue});
}

/// @nodoc
class __$$CacheImplCopyWithImpl<$Res>
    extends _$CacheCopyWithImpl<$Res, _$CacheImpl>
    implements _$$CacheImplCopyWith<$Res> {
  __$$CacheImplCopyWithImpl(
      _$CacheImpl _value, $Res Function(_$CacheImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cache
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cachePath = freezed,
    Object? cacheSize = freezed,
    Object? cacheVersion = freezed,
    Object? cachedInfo = freezed,
    Object? clearingQueue = freezed,
  }) {
    return _then(_$CacheImpl(
      cachePath: freezed == cachePath
          ? _value.cachePath
          : cachePath // ignore: cast_nullable_to_non_nullable
              as String?,
      cacheSize: freezed == cacheSize
          ? _value.cacheSize
          : cacheSize // ignore: cast_nullable_to_non_nullable
              as int?,
      cacheVersion: freezed == cacheVersion
          ? _value.cacheVersion
          : cacheVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      cachedInfo: freezed == cachedInfo
          ? _value._cachedInfo
          : cachedInfo // ignore: cast_nullable_to_non_nullable
              as List<CachedInfo>?,
      clearingQueue: freezed == clearingQueue
          ? _value._clearingQueue
          : clearingQueue // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CacheImpl implements _Cache {
  const _$CacheImpl(
      {@JsonKey(name: 'cachePath') this.cachePath,
      @JsonKey(name: 'cacheSize') this.cacheSize,
      @JsonKey(name: 'cacheVersion') this.cacheVersion,
      @JsonKey(name: 'cachedInfo') final List<CachedInfo>? cachedInfo,
      @JsonKey(name: 'clearingQueue') final List<String>? clearingQueue})
      : _cachedInfo = cachedInfo,
        _clearingQueue = clearingQueue;

  factory _$CacheImpl.fromJson(Map<String, dynamic> json) =>
      _$$CacheImplFromJson(json);

  @override
  @JsonKey(name: 'cachePath')
  final String? cachePath;
  @override
  @JsonKey(name: 'cacheSize')
  final int? cacheSize;
  @override
  @JsonKey(name: 'cacheVersion')
  final int? cacheVersion;
  final List<CachedInfo>? _cachedInfo;
  @override
  @JsonKey(name: 'cachedInfo')
  List<CachedInfo>? get cachedInfo {
    final value = _cachedInfo;
    if (value == null) return null;
    if (_cachedInfo is EqualUnmodifiableListView) return _cachedInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _clearingQueue;
  @override
  @JsonKey(name: 'clearingQueue')
  List<String>? get clearingQueue {
    final value = _clearingQueue;
    if (value == null) return null;
    if (_clearingQueue is EqualUnmodifiableListView) return _clearingQueue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Cache(cachePath: $cachePath, cacheSize: $cacheSize, cacheVersion: $cacheVersion, cachedInfo: $cachedInfo, clearingQueue: $clearingQueue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CacheImpl &&
            (identical(other.cachePath, cachePath) ||
                other.cachePath == cachePath) &&
            (identical(other.cacheSize, cacheSize) ||
                other.cacheSize == cacheSize) &&
            (identical(other.cacheVersion, cacheVersion) ||
                other.cacheVersion == cacheVersion) &&
            const DeepCollectionEquality()
                .equals(other._cachedInfo, _cachedInfo) &&
            const DeepCollectionEquality()
                .equals(other._clearingQueue, _clearingQueue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cachePath,
      cacheSize,
      cacheVersion,
      const DeepCollectionEquality().hash(_cachedInfo),
      const DeepCollectionEquality().hash(_clearingQueue));

  /// Create a copy of Cache
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CacheImplCopyWith<_$CacheImpl> get copyWith =>
      __$$CacheImplCopyWithImpl<_$CacheImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CacheImplToJson(
      this,
    );
  }
}

abstract class _Cache implements Cache {
  const factory _Cache(
          {@JsonKey(name: 'cachePath') final String? cachePath,
          @JsonKey(name: 'cacheSize') final int? cacheSize,
          @JsonKey(name: 'cacheVersion') final int? cacheVersion,
          @JsonKey(name: 'cachedInfo') final List<CachedInfo>? cachedInfo,
          @JsonKey(name: 'clearingQueue') final List<String>? clearingQueue}) =
      _$CacheImpl;

  factory _Cache.fromJson(Map<String, dynamic> json) = _$CacheImpl.fromJson;

  @override
  @JsonKey(name: 'cachePath')
  String? get cachePath;
  @override
  @JsonKey(name: 'cacheSize')
  int? get cacheSize;
  @override
  @JsonKey(name: 'cacheVersion')
  int? get cacheVersion;
  @override
  @JsonKey(name: 'cachedInfo')
  List<CachedInfo>? get cachedInfo;
  @override
  @JsonKey(name: 'clearingQueue')
  List<String>? get clearingQueue;

  /// Create a copy of Cache
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CacheImplCopyWith<_$CacheImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CachedInfo _$CachedInfoFromJson(Map<String, dynamic> json) {
  return _CachedInfo.fromJson(json);
}

/// @nodoc
mixin _$CachedInfo {
  @JsonKey(name: 'hintId')
  String? get hintId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lensId')
  String? get lensId => throw _privateConstructorUsedError;
  @JsonKey(name: 'signature')
  String? get signature => throw _privateConstructorUsedError;
  @JsonKey(name: 'signatureVersion')
  int? get signatureVersion => throw _privateConstructorUsedError;

  /// Serializes this CachedInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CachedInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CachedInfoCopyWith<CachedInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CachedInfoCopyWith<$Res> {
  factory $CachedInfoCopyWith(
          CachedInfo value, $Res Function(CachedInfo) then) =
      _$CachedInfoCopyWithImpl<$Res, CachedInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'hintId') String? hintId,
      @JsonKey(name: 'lensId') String? lensId,
      @JsonKey(name: 'signature') String? signature,
      @JsonKey(name: 'signatureVersion') int? signatureVersion});
}

/// @nodoc
class _$CachedInfoCopyWithImpl<$Res, $Val extends CachedInfo>
    implements $CachedInfoCopyWith<$Res> {
  _$CachedInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CachedInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hintId = freezed,
    Object? lensId = freezed,
    Object? signature = freezed,
    Object? signatureVersion = freezed,
  }) {
    return _then(_value.copyWith(
      hintId: freezed == hintId
          ? _value.hintId
          : hintId // ignore: cast_nullable_to_non_nullable
              as String?,
      lensId: freezed == lensId
          ? _value.lensId
          : lensId // ignore: cast_nullable_to_non_nullable
              as String?,
      signature: freezed == signature
          ? _value.signature
          : signature // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureVersion: freezed == signatureVersion
          ? _value.signatureVersion
          : signatureVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CachedInfoImplCopyWith<$Res>
    implements $CachedInfoCopyWith<$Res> {
  factory _$$CachedInfoImplCopyWith(
          _$CachedInfoImpl value, $Res Function(_$CachedInfoImpl) then) =
      __$$CachedInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'hintId') String? hintId,
      @JsonKey(name: 'lensId') String? lensId,
      @JsonKey(name: 'signature') String? signature,
      @JsonKey(name: 'signatureVersion') int? signatureVersion});
}

/// @nodoc
class __$$CachedInfoImplCopyWithImpl<$Res>
    extends _$CachedInfoCopyWithImpl<$Res, _$CachedInfoImpl>
    implements _$$CachedInfoImplCopyWith<$Res> {
  __$$CachedInfoImplCopyWithImpl(
      _$CachedInfoImpl _value, $Res Function(_$CachedInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CachedInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hintId = freezed,
    Object? lensId = freezed,
    Object? signature = freezed,
    Object? signatureVersion = freezed,
  }) {
    return _then(_$CachedInfoImpl(
      hintId: freezed == hintId
          ? _value.hintId
          : hintId // ignore: cast_nullable_to_non_nullable
              as String?,
      lensId: freezed == lensId
          ? _value.lensId
          : lensId // ignore: cast_nullable_to_non_nullable
              as String?,
      signature: freezed == signature
          ? _value.signature
          : signature // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureVersion: freezed == signatureVersion
          ? _value.signatureVersion
          : signatureVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CachedInfoImpl implements _CachedInfo {
  const _$CachedInfoImpl(
      {@JsonKey(name: 'hintId') this.hintId,
      @JsonKey(name: 'lensId') this.lensId,
      @JsonKey(name: 'signature') this.signature,
      @JsonKey(name: 'signatureVersion') this.signatureVersion});

  factory _$CachedInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CachedInfoImplFromJson(json);

  @override
  @JsonKey(name: 'hintId')
  final String? hintId;
  @override
  @JsonKey(name: 'lensId')
  final String? lensId;
  @override
  @JsonKey(name: 'signature')
  final String? signature;
  @override
  @JsonKey(name: 'signatureVersion')
  final int? signatureVersion;

  @override
  String toString() {
    return 'CachedInfo(hintId: $hintId, lensId: $lensId, signature: $signature, signatureVersion: $signatureVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CachedInfoImpl &&
            (identical(other.hintId, hintId) || other.hintId == hintId) &&
            (identical(other.lensId, lensId) || other.lensId == lensId) &&
            (identical(other.signature, signature) ||
                other.signature == signature) &&
            (identical(other.signatureVersion, signatureVersion) ||
                other.signatureVersion == signatureVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hintId, lensId, signature, signatureVersion);

  /// Create a copy of CachedInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CachedInfoImplCopyWith<_$CachedInfoImpl> get copyWith =>
      __$$CachedInfoImplCopyWithImpl<_$CachedInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CachedInfoImplToJson(
      this,
    );
  }
}

abstract class _CachedInfo implements CachedInfo {
  const factory _CachedInfo(
          {@JsonKey(name: 'hintId') final String? hintId,
          @JsonKey(name: 'lensId') final String? lensId,
          @JsonKey(name: 'signature') final String? signature,
          @JsonKey(name: 'signatureVersion') final int? signatureVersion}) =
      _$CachedInfoImpl;

  factory _CachedInfo.fromJson(Map<String, dynamic> json) =
      _$CachedInfoImpl.fromJson;

  @override
  @JsonKey(name: 'hintId')
  String? get hintId;
  @override
  @JsonKey(name: 'lensId')
  String? get lensId;
  @override
  @JsonKey(name: 'signature')
  String? get signature;
  @override
  @JsonKey(name: 'signatureVersion')
  int? get signatureVersion;

  /// Create a copy of CachedInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CachedInfoImplCopyWith<_$CachedInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Core _$CoreFromJson(Map<String, dynamic> json) {
  return _Core.fromJson(json);
}

/// @nodoc
mixin _$Core {
  @JsonKey(name: 'disableColorCorrection')
  bool? get disableColorCorrection => throw _privateConstructorUsedError;
  @JsonKey(name: 'microphone')
  String? get microphone => throw _privateConstructorUsedError;
  @JsonKey(name: 'showOverlay')
  bool? get showOverlay => throw _privateConstructorUsedError;
  @JsonKey(name: 'webcam')
  String? get webcam => throw _privateConstructorUsedError;
  @JsonKey(name: 'webcamResolution')
  String? get webcamResolution => throw _privateConstructorUsedError;

  /// Serializes this Core to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Core
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoreCopyWith<Core> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoreCopyWith<$Res> {
  factory $CoreCopyWith(Core value, $Res Function(Core) then) =
      _$CoreCopyWithImpl<$Res, Core>;
  @useResult
  $Res call(
      {@JsonKey(name: 'disableColorCorrection') bool? disableColorCorrection,
      @JsonKey(name: 'microphone') String? microphone,
      @JsonKey(name: 'showOverlay') bool? showOverlay,
      @JsonKey(name: 'webcam') String? webcam,
      @JsonKey(name: 'webcamResolution') String? webcamResolution});
}

/// @nodoc
class _$CoreCopyWithImpl<$Res, $Val extends Core>
    implements $CoreCopyWith<$Res> {
  _$CoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Core
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disableColorCorrection = freezed,
    Object? microphone = freezed,
    Object? showOverlay = freezed,
    Object? webcam = freezed,
    Object? webcamResolution = freezed,
  }) {
    return _then(_value.copyWith(
      disableColorCorrection: freezed == disableColorCorrection
          ? _value.disableColorCorrection
          : disableColorCorrection // ignore: cast_nullable_to_non_nullable
              as bool?,
      microphone: freezed == microphone
          ? _value.microphone
          : microphone // ignore: cast_nullable_to_non_nullable
              as String?,
      showOverlay: freezed == showOverlay
          ? _value.showOverlay
          : showOverlay // ignore: cast_nullable_to_non_nullable
              as bool?,
      webcam: freezed == webcam
          ? _value.webcam
          : webcam // ignore: cast_nullable_to_non_nullable
              as String?,
      webcamResolution: freezed == webcamResolution
          ? _value.webcamResolution
          : webcamResolution // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoreImplCopyWith<$Res> implements $CoreCopyWith<$Res> {
  factory _$$CoreImplCopyWith(
          _$CoreImpl value, $Res Function(_$CoreImpl) then) =
      __$$CoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'disableColorCorrection') bool? disableColorCorrection,
      @JsonKey(name: 'microphone') String? microphone,
      @JsonKey(name: 'showOverlay') bool? showOverlay,
      @JsonKey(name: 'webcam') String? webcam,
      @JsonKey(name: 'webcamResolution') String? webcamResolution});
}

/// @nodoc
class __$$CoreImplCopyWithImpl<$Res>
    extends _$CoreCopyWithImpl<$Res, _$CoreImpl>
    implements _$$CoreImplCopyWith<$Res> {
  __$$CoreImplCopyWithImpl(_$CoreImpl _value, $Res Function(_$CoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of Core
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disableColorCorrection = freezed,
    Object? microphone = freezed,
    Object? showOverlay = freezed,
    Object? webcam = freezed,
    Object? webcamResolution = freezed,
  }) {
    return _then(_$CoreImpl(
      disableColorCorrection: freezed == disableColorCorrection
          ? _value.disableColorCorrection
          : disableColorCorrection // ignore: cast_nullable_to_non_nullable
              as bool?,
      microphone: freezed == microphone
          ? _value.microphone
          : microphone // ignore: cast_nullable_to_non_nullable
              as String?,
      showOverlay: freezed == showOverlay
          ? _value.showOverlay
          : showOverlay // ignore: cast_nullable_to_non_nullable
              as bool?,
      webcam: freezed == webcam
          ? _value.webcam
          : webcam // ignore: cast_nullable_to_non_nullable
              as String?,
      webcamResolution: freezed == webcamResolution
          ? _value.webcamResolution
          : webcamResolution // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoreImpl implements _Core {
  const _$CoreImpl(
      {@JsonKey(name: 'disableColorCorrection') this.disableColorCorrection,
      @JsonKey(name: 'microphone') this.microphone,
      @JsonKey(name: 'showOverlay') this.showOverlay,
      @JsonKey(name: 'webcam') this.webcam,
      @JsonKey(name: 'webcamResolution') this.webcamResolution});

  factory _$CoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoreImplFromJson(json);

  @override
  @JsonKey(name: 'disableColorCorrection')
  final bool? disableColorCorrection;
  @override
  @JsonKey(name: 'microphone')
  final String? microphone;
  @override
  @JsonKey(name: 'showOverlay')
  final bool? showOverlay;
  @override
  @JsonKey(name: 'webcam')
  final String? webcam;
  @override
  @JsonKey(name: 'webcamResolution')
  final String? webcamResolution;

  @override
  String toString() {
    return 'Core(disableColorCorrection: $disableColorCorrection, microphone: $microphone, showOverlay: $showOverlay, webcam: $webcam, webcamResolution: $webcamResolution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoreImpl &&
            (identical(other.disableColorCorrection, disableColorCorrection) ||
                other.disableColorCorrection == disableColorCorrection) &&
            (identical(other.microphone, microphone) ||
                other.microphone == microphone) &&
            (identical(other.showOverlay, showOverlay) ||
                other.showOverlay == showOverlay) &&
            (identical(other.webcam, webcam) || other.webcam == webcam) &&
            (identical(other.webcamResolution, webcamResolution) ||
                other.webcamResolution == webcamResolution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, disableColorCorrection,
      microphone, showOverlay, webcam, webcamResolution);

  /// Create a copy of Core
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoreImplCopyWith<_$CoreImpl> get copyWith =>
      __$$CoreImplCopyWithImpl<_$CoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoreImplToJson(
      this,
    );
  }
}

abstract class _Core implements Core {
  const factory _Core(
          {@JsonKey(name: 'disableColorCorrection')
          final bool? disableColorCorrection,
          @JsonKey(name: 'microphone') final String? microphone,
          @JsonKey(name: 'showOverlay') final bool? showOverlay,
          @JsonKey(name: 'webcam') final String? webcam,
          @JsonKey(name: 'webcamResolution') final String? webcamResolution}) =
      _$CoreImpl;

  factory _Core.fromJson(Map<String, dynamic> json) = _$CoreImpl.fromJson;

  @override
  @JsonKey(name: 'disableColorCorrection')
  bool? get disableColorCorrection;
  @override
  @JsonKey(name: 'microphone')
  String? get microphone;
  @override
  @JsonKey(name: 'showOverlay')
  bool? get showOverlay;
  @override
  @JsonKey(name: 'webcam')
  String? get webcam;
  @override
  @JsonKey(name: 'webcamResolution')
  String? get webcamResolution;

  /// Create a copy of Core
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoreImplCopyWith<_$CoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
