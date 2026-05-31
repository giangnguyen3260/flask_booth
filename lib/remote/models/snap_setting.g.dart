// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snap_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnapSettingImpl _$$SnapSettingImplFromJson(Map<String, dynamic> json) =>
    _$SnapSettingImpl(
      core: json['core'] == null
          ? null
          : Core.fromJson(json['core'] as Map<String, dynamic>),
      lenses: json['lenses'] == null
          ? null
          : Lenses.fromJson(json['lenses'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : Settings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SnapSettingImplToJson(_$SnapSettingImpl instance) =>
    <String, dynamic>{
      'core': instance.core,
      'lenses': instance.lenses,
      'settings': instance.settings,
    };

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      alwaysShowSnapcode: json['always_show_snapcode'] as bool?,
      automaticUpdates: json['automatic_updates'] as bool?,
      launchOnStartup: json['launch_on_startup'] as bool?,
      mirrorPreview: json['mirror_preview'] as bool?,
      recorderUnused: json['recorder_unused'] as bool?,
      shortcuts: json['shortcuts'] == null
          ? null
          : Shortcuts.fromJson(json['shortcuts'] as Map<String, dynamic>),
      shouldShowMakeCallHint: json['should_show_make_call_hint'] as bool?,
      showOnboarding: json['show_onboarding'] as bool?,
      skipVersion: json['skip_version'] == null
          ? null
          : SkipVersion.fromJson(json['skip_version'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'always_show_snapcode': instance.alwaysShowSnapcode,
      'automatic_updates': instance.automaticUpdates,
      'launch_on_startup': instance.launchOnStartup,
      'mirror_preview': instance.mirrorPreview,
      'recorder_unused': instance.recorderUnused,
      'shortcuts': instance.shortcuts,
      'should_show_make_call_hint': instance.shouldShowMakeCallHint,
      'show_onboarding': instance.showOnboarding,
      'skip_version': instance.skipVersion,
    };

_$SkipVersionImpl _$$SkipVersionImplFromJson(Map<String, dynamic> json) =>
    _$SkipVersionImpl(
      build: (json['build'] as num?)?.toInt(),
      major: (json['major'] as num?)?.toInt(),
      minor: (json['minor'] as num?)?.toInt(),
      patch: (json['patch'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SkipVersionImplToJson(_$SkipVersionImpl instance) =>
    <String, dynamic>{
      'build': instance.build,
      'major': instance.major,
      'minor': instance.minor,
      'patch': instance.patch,
    };

_$ShortcutsImpl _$$ShortcutsImplFromJson(Map<String, dynamic> json) =>
    _$ShortcutsImpl(
      lensesShortcuts: (json['lenses_shortcuts'] as List<dynamic>?)
          ?.map((e) => LensesShortcuts.fromJson(e as Map<String, dynamic>))
          .toList(),
      roleShortcuts: json['role_shortcuts'],
    );

Map<String, dynamic> _$$ShortcutsImplToJson(_$ShortcutsImpl instance) =>
    <String, dynamic>{
      'lenses_shortcuts': instance.lensesShortcuts,
      'role_shortcuts': instance.roleShortcuts,
    };

_$LensesShortcutsImpl _$$LensesShortcutsImplFromJson(
        Map<String, dynamic> json) =>
    _$LensesShortcutsImpl(
      lensId: json['lens_id'] as String?,
      shortcut: json['shortcut'] as String?,
    );

Map<String, dynamic> _$$LensesShortcutsImplToJson(
        _$LensesShortcutsImpl instance) =>
    <String, dynamic>{
      'lens_id': instance.lensId,
      'shortcut': instance.shortcut,
    };

_$LensesImpl _$$LensesImplFromJson(Map<String, dynamic> json) => _$LensesImpl(
      applyFirstScheduled: json['apply_first_scheduled'] as bool?,
      cache: json['cache'] == null
          ? null
          : Cache.fromJson(json['cache'] as Map<String, dynamic>),
      favorites: (json['favorites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recents: (json['recents'] as List<dynamic>?)
          ?.map((e) => Recents.fromJson(e as Map<String, dynamic>))
          .toList(),
      retouch: json['retouch'] as bool?,
    );

Map<String, dynamic> _$$LensesImplToJson(_$LensesImpl instance) =>
    <String, dynamic>{
      'apply_first_scheduled': instance.applyFirstScheduled,
      'cache': instance.cache,
      'favorites': instance.favorites,
      'recents': instance.recents,
      'retouch': instance.retouch,
    };

_$RecentsImpl _$$RecentsImplFromJson(Map<String, dynamic> json) =>
    _$RecentsImpl(
      lensId: json['lensId'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RecentsImplToJson(_$RecentsImpl instance) =>
    <String, dynamic>{
      'lensId': instance.lensId,
      'timestamp': instance.timestamp,
    };

_$CacheImpl _$$CacheImplFromJson(Map<String, dynamic> json) => _$CacheImpl(
      cachePath: json['cachePath'] as String?,
      cacheSize: (json['cacheSize'] as num?)?.toInt(),
      cacheVersion: (json['cacheVersion'] as num?)?.toInt(),
      cachedInfo: (json['cachedInfo'] as List<dynamic>?)
          ?.map((e) => CachedInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      clearingQueue: (json['clearingQueue'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CacheImplToJson(_$CacheImpl instance) =>
    <String, dynamic>{
      'cachePath': instance.cachePath,
      'cacheSize': instance.cacheSize,
      'cacheVersion': instance.cacheVersion,
      'cachedInfo': instance.cachedInfo,
      'clearingQueue': instance.clearingQueue,
    };

_$CachedInfoImpl _$$CachedInfoImplFromJson(Map<String, dynamic> json) =>
    _$CachedInfoImpl(
      hintId: json['hintId'] as String?,
      lensId: json['lensId'] as String?,
      signature: json['signature'] as String?,
      signatureVersion: (json['signatureVersion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CachedInfoImplToJson(_$CachedInfoImpl instance) =>
    <String, dynamic>{
      'hintId': instance.hintId,
      'lensId': instance.lensId,
      'signature': instance.signature,
      'signatureVersion': instance.signatureVersion,
    };

_$CoreImpl _$$CoreImplFromJson(Map<String, dynamic> json) => _$CoreImpl(
      disableColorCorrection: json['disableColorCorrection'] as bool?,
      microphone: json['microphone'] as String?,
      showOverlay: json['showOverlay'] as bool?,
      webcam: json['webcam'] as String?,
      webcamResolution: json['webcamResolution'] as String?,
    );

Map<String, dynamic> _$$CoreImplToJson(_$CoreImpl instance) =>
    <String, dynamic>{
      'disableColorCorrection': instance.disableColorCorrection,
      'microphone': instance.microphone,
      'showOverlay': instance.showOverlay,
      'webcam': instance.webcam,
      'webcamResolution': instance.webcamResolution,
    };
