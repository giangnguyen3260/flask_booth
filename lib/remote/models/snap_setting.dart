import 'package:freezed_annotation/freezed_annotation.dart';

part 'snap_setting.freezed.dart';
part 'snap_setting.g.dart';

@freezed
class SnapSetting with _$SnapSetting {
  const factory SnapSetting({
    @JsonKey(name: 'core') Core? core,
    @JsonKey(name: 'lenses') Lenses? lenses,
    @JsonKey(name: 'settings') Settings? settings,
  }) = _SnapSetting;

  factory SnapSetting.fromJson(Map<String, Object?> json) => _$SnapSettingFromJson(json);
}

@freezed
class Settings with _$Settings {
  const factory Settings({
    @JsonKey(name: 'always_show_snapcode') bool? alwaysShowSnapcode,
    @JsonKey(name: 'automatic_updates') bool? automaticUpdates,
    @JsonKey(name: 'launch_on_startup') bool? launchOnStartup,
    @JsonKey(name: 'mirror_preview') bool? mirrorPreview,
    @JsonKey(name: 'recorder_unused') bool? recorderUnused,
    @JsonKey(name: 'shortcuts') Shortcuts? shortcuts,
    @JsonKey(name: 'should_show_make_call_hint') bool? shouldShowMakeCallHint,
    @JsonKey(name: 'show_onboarding') bool? showOnboarding,
    @JsonKey(name: 'skip_version') SkipVersion? skipVersion,
  }) = _Settings;

  factory Settings.fromJson(Map<String, Object?> json) => _$SettingsFromJson(json);
}

@freezed
class SkipVersion with _$SkipVersion {
  const factory SkipVersion({
    @JsonKey(name: 'build') int? build,
    @JsonKey(name: 'major') int? major,
    @JsonKey(name: 'minor') int? minor,
    @JsonKey(name: 'patch') int? patch,
  }) = _SkipVersion;

  factory SkipVersion.fromJson(Map<String, Object?> json) => _$SkipVersionFromJson(json);
}

@freezed
class Shortcuts with _$Shortcuts {
  const factory Shortcuts({
    @JsonKey(name: 'lenses_shortcuts') List<LensesShortcuts>? lensesShortcuts,
    @JsonKey(name: 'role_shortcuts') dynamic roleShortcuts,
  }) = _Shortcuts;

  factory Shortcuts.fromJson(Map<String, Object?> json) => _$ShortcutsFromJson(json);
}

@freezed
class LensesShortcuts with _$LensesShortcuts {
  const factory LensesShortcuts({
    @JsonKey(name: 'lens_id') String? lensId,
    @JsonKey(name: 'shortcut') String? shortcut,
  }) = _LensesShortcuts;

  factory LensesShortcuts.fromJson(Map<String, Object?> json) => _$LensesShortcutsFromJson(json);
}

@freezed
class Lenses with _$Lenses {
  const factory Lenses({
    @JsonKey(name: 'apply_first_scheduled') bool? applyFirstScheduled,
    @JsonKey(name: 'cache') Cache? cache,
    @JsonKey(name: 'favorites') List<String>? favorites,
    @JsonKey(name: 'recents') List<Recents>? recents,
    @JsonKey(name: 'retouch') bool? retouch,
  }) = _Lenses;

  factory Lenses.fromJson(Map<String, Object?> json) => _$LensesFromJson(json);
}

@freezed
class Recents with _$Recents {
  const factory Recents({
    @JsonKey(name: 'lensId') String? lensId,
    @JsonKey(name: 'timestamp') int? timestamp,
  }) = _Recents;

  factory Recents.fromJson(Map<String, Object?> json) => _$RecentsFromJson(json);
}

@freezed
class Cache with _$Cache {
  const factory Cache({
    @JsonKey(name: 'cachePath') String? cachePath,
    @JsonKey(name: 'cacheSize') int? cacheSize,
    @JsonKey(name: 'cacheVersion') int? cacheVersion,
    @JsonKey(name: 'cachedInfo') List<CachedInfo>? cachedInfo,
    @JsonKey(name: 'clearingQueue') List<String>? clearingQueue,
  }) = _Cache;

  factory Cache.fromJson(Map<String, Object?> json) => _$CacheFromJson(json);
}

@freezed
class CachedInfo with _$CachedInfo {
  const factory CachedInfo({
    @JsonKey(name: 'hintId') String? hintId,
    @JsonKey(name: 'lensId') String? lensId,
    @JsonKey(name: 'signature') String? signature,
    @JsonKey(name: 'signatureVersion') int? signatureVersion,
  }) = _CachedInfo;

  factory CachedInfo.fromJson(Map<String, Object?> json) => _$CachedInfoFromJson(json);
}

@freezed
class Core with _$Core {
  const factory Core({
    @JsonKey(name: 'disableColorCorrection') bool? disableColorCorrection,
    @JsonKey(name: 'microphone') String? microphone,
    @JsonKey(name: 'showOverlay') bool? showOverlay,
    @JsonKey(name: 'webcam') String? webcam,
    @JsonKey(name: 'webcamResolution') String? webcamResolution,
  }) = _Core;

  factory Core.fromJson(Map<String, Object?> json) => _$CoreFromJson(json);
}

