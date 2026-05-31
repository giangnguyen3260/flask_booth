// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kiosk_heartbeat_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KioskHeartbeatResponse _$KioskHeartbeatResponseFromJson(
    Map<String, dynamic> json) {
  return _KioskHeartbeatResponse.fromJson(json);
}

/// @nodoc
mixin _$KioskHeartbeatResponse {
  @JsonKey(name: 'kioskCode')
  String? get kioskCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'active')
  bool? get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenanceMode')
  bool? get maintenanceMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currentScreen')
  String? get currentScreen => throw _privateConstructorUsedError;
  @JsonKey(name: 'currentSessionId')
  String? get currentSessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastSeenAt')
  String? get lastSeenAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'pendingCommands')
  int? get pendingCommands => throw _privateConstructorUsedError;
  @JsonKey(name: 'serverTime')
  String? get serverTime => throw _privateConstructorUsedError;

  /// Serializes this KioskHeartbeatResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KioskHeartbeatResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KioskHeartbeatResponseCopyWith<KioskHeartbeatResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KioskHeartbeatResponseCopyWith<$Res> {
  factory $KioskHeartbeatResponseCopyWith(KioskHeartbeatResponse value,
          $Res Function(KioskHeartbeatResponse) then) =
      _$KioskHeartbeatResponseCopyWithImpl<$Res, KioskHeartbeatResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'kioskCode') String? kioskCode,
      @JsonKey(name: 'active') bool? active,
      @JsonKey(name: 'maintenanceMode') bool? maintenanceMode,
      @JsonKey(name: 'currentScreen') String? currentScreen,
      @JsonKey(name: 'currentSessionId') String? currentSessionId,
      @JsonKey(name: 'lastSeenAt') String? lastSeenAt,
      @JsonKey(name: 'pendingCommands') int? pendingCommands,
      @JsonKey(name: 'serverTime') String? serverTime});
}

/// @nodoc
class _$KioskHeartbeatResponseCopyWithImpl<$Res,
        $Val extends KioskHeartbeatResponse>
    implements $KioskHeartbeatResponseCopyWith<$Res> {
  _$KioskHeartbeatResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KioskHeartbeatResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kioskCode = freezed,
    Object? active = freezed,
    Object? maintenanceMode = freezed,
    Object? currentScreen = freezed,
    Object? currentSessionId = freezed,
    Object? lastSeenAt = freezed,
    Object? pendingCommands = freezed,
    Object? serverTime = freezed,
  }) {
    return _then(_value.copyWith(
      kioskCode: freezed == kioskCode
          ? _value.kioskCode
          : kioskCode // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      maintenanceMode: freezed == maintenanceMode
          ? _value.maintenanceMode
          : maintenanceMode // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentScreen: freezed == currentScreen
          ? _value.currentScreen
          : currentScreen // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSessionId: freezed == currentSessionId
          ? _value.currentSessionId
          : currentSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingCommands: freezed == pendingCommands
          ? _value.pendingCommands
          : pendingCommands // ignore: cast_nullable_to_non_nullable
              as int?,
      serverTime: freezed == serverTime
          ? _value.serverTime
          : serverTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KioskHeartbeatResponseImplCopyWith<$Res>
    implements $KioskHeartbeatResponseCopyWith<$Res> {
  factory _$$KioskHeartbeatResponseImplCopyWith(
          _$KioskHeartbeatResponseImpl value,
          $Res Function(_$KioskHeartbeatResponseImpl) then) =
      __$$KioskHeartbeatResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'kioskCode') String? kioskCode,
      @JsonKey(name: 'active') bool? active,
      @JsonKey(name: 'maintenanceMode') bool? maintenanceMode,
      @JsonKey(name: 'currentScreen') String? currentScreen,
      @JsonKey(name: 'currentSessionId') String? currentSessionId,
      @JsonKey(name: 'lastSeenAt') String? lastSeenAt,
      @JsonKey(name: 'pendingCommands') int? pendingCommands,
      @JsonKey(name: 'serverTime') String? serverTime});
}

/// @nodoc
class __$$KioskHeartbeatResponseImplCopyWithImpl<$Res>
    extends _$KioskHeartbeatResponseCopyWithImpl<$Res,
        _$KioskHeartbeatResponseImpl>
    implements _$$KioskHeartbeatResponseImplCopyWith<$Res> {
  __$$KioskHeartbeatResponseImplCopyWithImpl(
      _$KioskHeartbeatResponseImpl _value,
      $Res Function(_$KioskHeartbeatResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of KioskHeartbeatResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kioskCode = freezed,
    Object? active = freezed,
    Object? maintenanceMode = freezed,
    Object? currentScreen = freezed,
    Object? currentSessionId = freezed,
    Object? lastSeenAt = freezed,
    Object? pendingCommands = freezed,
    Object? serverTime = freezed,
  }) {
    return _then(_$KioskHeartbeatResponseImpl(
      kioskCode: freezed == kioskCode
          ? _value.kioskCode
          : kioskCode // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      maintenanceMode: freezed == maintenanceMode
          ? _value.maintenanceMode
          : maintenanceMode // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentScreen: freezed == currentScreen
          ? _value.currentScreen
          : currentScreen // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSessionId: freezed == currentSessionId
          ? _value.currentSessionId
          : currentSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingCommands: freezed == pendingCommands
          ? _value.pendingCommands
          : pendingCommands // ignore: cast_nullable_to_non_nullable
              as int?,
      serverTime: freezed == serverTime
          ? _value.serverTime
          : serverTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KioskHeartbeatResponseImpl implements _KioskHeartbeatResponse {
  const _$KioskHeartbeatResponseImpl(
      {@JsonKey(name: 'kioskCode') this.kioskCode,
      @JsonKey(name: 'active') this.active,
      @JsonKey(name: 'maintenanceMode') this.maintenanceMode,
      @JsonKey(name: 'currentScreen') this.currentScreen,
      @JsonKey(name: 'currentSessionId') this.currentSessionId,
      @JsonKey(name: 'lastSeenAt') this.lastSeenAt,
      @JsonKey(name: 'pendingCommands') this.pendingCommands,
      @JsonKey(name: 'serverTime') this.serverTime});

  factory _$KioskHeartbeatResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$KioskHeartbeatResponseImplFromJson(json);

  @override
  @JsonKey(name: 'kioskCode')
  final String? kioskCode;
  @override
  @JsonKey(name: 'active')
  final bool? active;
  @override
  @JsonKey(name: 'maintenanceMode')
  final bool? maintenanceMode;
  @override
  @JsonKey(name: 'currentScreen')
  final String? currentScreen;
  @override
  @JsonKey(name: 'currentSessionId')
  final String? currentSessionId;
  @override
  @JsonKey(name: 'lastSeenAt')
  final String? lastSeenAt;
  @override
  @JsonKey(name: 'pendingCommands')
  final int? pendingCommands;
  @override
  @JsonKey(name: 'serverTime')
  final String? serverTime;

  @override
  String toString() {
    return 'KioskHeartbeatResponse(kioskCode: $kioskCode, active: $active, maintenanceMode: $maintenanceMode, currentScreen: $currentScreen, currentSessionId: $currentSessionId, lastSeenAt: $lastSeenAt, pendingCommands: $pendingCommands, serverTime: $serverTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KioskHeartbeatResponseImpl &&
            (identical(other.kioskCode, kioskCode) ||
                other.kioskCode == kioskCode) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.maintenanceMode, maintenanceMode) ||
                other.maintenanceMode == maintenanceMode) &&
            (identical(other.currentScreen, currentScreen) ||
                other.currentScreen == currentScreen) &&
            (identical(other.currentSessionId, currentSessionId) ||
                other.currentSessionId == currentSessionId) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt) &&
            (identical(other.pendingCommands, pendingCommands) ||
                other.pendingCommands == pendingCommands) &&
            (identical(other.serverTime, serverTime) ||
                other.serverTime == serverTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      kioskCode,
      active,
      maintenanceMode,
      currentScreen,
      currentSessionId,
      lastSeenAt,
      pendingCommands,
      serverTime);

  /// Create a copy of KioskHeartbeatResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KioskHeartbeatResponseImplCopyWith<_$KioskHeartbeatResponseImpl>
      get copyWith => __$$KioskHeartbeatResponseImplCopyWithImpl<
          _$KioskHeartbeatResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KioskHeartbeatResponseImplToJson(
      this,
    );
  }
}

abstract class _KioskHeartbeatResponse implements KioskHeartbeatResponse {
  const factory _KioskHeartbeatResponse(
          {@JsonKey(name: 'kioskCode') final String? kioskCode,
          @JsonKey(name: 'active') final bool? active,
          @JsonKey(name: 'maintenanceMode') final bool? maintenanceMode,
          @JsonKey(name: 'currentScreen') final String? currentScreen,
          @JsonKey(name: 'currentSessionId') final String? currentSessionId,
          @JsonKey(name: 'lastSeenAt') final String? lastSeenAt,
          @JsonKey(name: 'pendingCommands') final int? pendingCommands,
          @JsonKey(name: 'serverTime') final String? serverTime}) =
      _$KioskHeartbeatResponseImpl;

  factory _KioskHeartbeatResponse.fromJson(Map<String, dynamic> json) =
      _$KioskHeartbeatResponseImpl.fromJson;

  @override
  @JsonKey(name: 'kioskCode')
  String? get kioskCode;
  @override
  @JsonKey(name: 'active')
  bool? get active;
  @override
  @JsonKey(name: 'maintenanceMode')
  bool? get maintenanceMode;
  @override
  @JsonKey(name: 'currentScreen')
  String? get currentScreen;
  @override
  @JsonKey(name: 'currentSessionId')
  String? get currentSessionId;
  @override
  @JsonKey(name: 'lastSeenAt')
  String? get lastSeenAt;
  @override
  @JsonKey(name: 'pendingCommands')
  int? get pendingCommands;
  @override
  @JsonKey(name: 'serverTime')
  String? get serverTime;

  /// Create a copy of KioskHeartbeatResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KioskHeartbeatResponseImplCopyWith<_$KioskHeartbeatResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
