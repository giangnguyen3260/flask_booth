// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kiosk_event_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KioskEventResponse _$KioskEventResponseFromJson(Map<String, dynamic> json) {
  return _KioskEventResponse.fromJson(json);
}

/// @nodoc
mixin _$KioskEventResponse {
  @JsonKey(name: 'eventId')
  String? get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'eventType')
  String? get eventType => throw _privateConstructorUsedError;
  @JsonKey(name: 'occurredAt')
  String? get occurredAt => throw _privateConstructorUsedError;

  /// Serializes this KioskEventResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KioskEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KioskEventResponseCopyWith<KioskEventResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KioskEventResponseCopyWith<$Res> {
  factory $KioskEventResponseCopyWith(
          KioskEventResponse value, $Res Function(KioskEventResponse) then) =
      _$KioskEventResponseCopyWithImpl<$Res, KioskEventResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'eventId') String? eventId,
      @JsonKey(name: 'eventType') String? eventType,
      @JsonKey(name: 'occurredAt') String? occurredAt});
}

/// @nodoc
class _$KioskEventResponseCopyWithImpl<$Res, $Val extends KioskEventResponse>
    implements $KioskEventResponseCopyWith<$Res> {
  _$KioskEventResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KioskEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? eventType = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: freezed == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String?,
      occurredAt: freezed == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KioskEventResponseImplCopyWith<$Res>
    implements $KioskEventResponseCopyWith<$Res> {
  factory _$$KioskEventResponseImplCopyWith(_$KioskEventResponseImpl value,
          $Res Function(_$KioskEventResponseImpl) then) =
      __$$KioskEventResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'eventId') String? eventId,
      @JsonKey(name: 'eventType') String? eventType,
      @JsonKey(name: 'occurredAt') String? occurredAt});
}

/// @nodoc
class __$$KioskEventResponseImplCopyWithImpl<$Res>
    extends _$KioskEventResponseCopyWithImpl<$Res, _$KioskEventResponseImpl>
    implements _$$KioskEventResponseImplCopyWith<$Res> {
  __$$KioskEventResponseImplCopyWithImpl(_$KioskEventResponseImpl _value,
      $Res Function(_$KioskEventResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of KioskEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? eventType = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(_$KioskEventResponseImpl(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: freezed == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String?,
      occurredAt: freezed == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KioskEventResponseImpl implements _KioskEventResponse {
  const _$KioskEventResponseImpl(
      {@JsonKey(name: 'eventId') this.eventId,
      @JsonKey(name: 'eventType') this.eventType,
      @JsonKey(name: 'occurredAt') this.occurredAt});

  factory _$KioskEventResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$KioskEventResponseImplFromJson(json);

  @override
  @JsonKey(name: 'eventId')
  final String? eventId;
  @override
  @JsonKey(name: 'eventType')
  final String? eventType;
  @override
  @JsonKey(name: 'occurredAt')
  final String? occurredAt;

  @override
  String toString() {
    return 'KioskEventResponse(eventId: $eventId, eventType: $eventType, occurredAt: $occurredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KioskEventResponseImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, eventType, occurredAt);

  /// Create a copy of KioskEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KioskEventResponseImplCopyWith<_$KioskEventResponseImpl> get copyWith =>
      __$$KioskEventResponseImplCopyWithImpl<_$KioskEventResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KioskEventResponseImplToJson(
      this,
    );
  }
}

abstract class _KioskEventResponse implements KioskEventResponse {
  const factory _KioskEventResponse(
          {@JsonKey(name: 'eventId') final String? eventId,
          @JsonKey(name: 'eventType') final String? eventType,
          @JsonKey(name: 'occurredAt') final String? occurredAt}) =
      _$KioskEventResponseImpl;

  factory _KioskEventResponse.fromJson(Map<String, dynamic> json) =
      _$KioskEventResponseImpl.fromJson;

  @override
  @JsonKey(name: 'eventId')
  String? get eventId;
  @override
  @JsonKey(name: 'eventType')
  String? get eventType;
  @override
  @JsonKey(name: 'occurredAt')
  String? get occurredAt;

  /// Create a copy of KioskEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KioskEventResponseImplCopyWith<_$KioskEventResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
