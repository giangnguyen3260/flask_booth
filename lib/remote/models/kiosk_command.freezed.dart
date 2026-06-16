// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kiosk_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KioskCommand _$KioskCommandFromJson(Map<String, dynamic> json) {
  return _KioskCommand.fromJson(json);
}

/// @nodoc
mixin _$KioskCommand {
  @JsonKey(name: 'commandId')
  String? get commandId => throw _privateConstructorUsedError;
  @JsonKey(name: 'commandType')
  String? get commandType => throw _privateConstructorUsedError;
  @JsonKey(name: 'payload')
  KioskCommandPayload? get payload => throw _privateConstructorUsedError;

  /// Serializes this KioskCommand to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KioskCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KioskCommandCopyWith<KioskCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KioskCommandCopyWith<$Res> {
  factory $KioskCommandCopyWith(
          KioskCommand value, $Res Function(KioskCommand) then) =
      _$KioskCommandCopyWithImpl<$Res, KioskCommand>;
  @useResult
  $Res call(
      {@JsonKey(name: 'commandId') String? commandId,
      @JsonKey(name: 'commandType') String? commandType,
      @JsonKey(name: 'payload') KioskCommandPayload? payload});

  $KioskCommandPayloadCopyWith<$Res>? get payload;
}

/// @nodoc
class _$KioskCommandCopyWithImpl<$Res, $Val extends KioskCommand>
    implements $KioskCommandCopyWith<$Res> {
  _$KioskCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KioskCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commandId = freezed,
    Object? commandType = freezed,
    Object? payload = freezed,
  }) {
    return _then(_value.copyWith(
      commandId: freezed == commandId
          ? _value.commandId
          : commandId // ignore: cast_nullable_to_non_nullable
              as String?,
      commandType: freezed == commandType
          ? _value.commandType
          : commandType // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as KioskCommandPayload?,
    ) as $Val);
  }

  /// Create a copy of KioskCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KioskCommandPayloadCopyWith<$Res>? get payload {
    if (_value.payload == null) {
      return null;
    }

    return $KioskCommandPayloadCopyWith<$Res>(_value.payload!, (value) {
      return _then(_value.copyWith(payload: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$KioskCommandImplCopyWith<$Res>
    implements $KioskCommandCopyWith<$Res> {
  factory _$$KioskCommandImplCopyWith(
          _$KioskCommandImpl value, $Res Function(_$KioskCommandImpl) then) =
      __$$KioskCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'commandId') String? commandId,
      @JsonKey(name: 'commandType') String? commandType,
      @JsonKey(name: 'payload') KioskCommandPayload? payload});

  @override
  $KioskCommandPayloadCopyWith<$Res>? get payload;
}

/// @nodoc
class __$$KioskCommandImplCopyWithImpl<$Res>
    extends _$KioskCommandCopyWithImpl<$Res, _$KioskCommandImpl>
    implements _$$KioskCommandImplCopyWith<$Res> {
  __$$KioskCommandImplCopyWithImpl(
      _$KioskCommandImpl _value, $Res Function(_$KioskCommandImpl) _then)
      : super(_value, _then);

  /// Create a copy of KioskCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commandId = freezed,
    Object? commandType = freezed,
    Object? payload = freezed,
  }) {
    return _then(_$KioskCommandImpl(
      commandId: freezed == commandId
          ? _value.commandId
          : commandId // ignore: cast_nullable_to_non_nullable
              as String?,
      commandType: freezed == commandType
          ? _value.commandType
          : commandType // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as KioskCommandPayload?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KioskCommandImpl implements _KioskCommand {
  const _$KioskCommandImpl(
      {@JsonKey(name: 'commandId') this.commandId,
      @JsonKey(name: 'commandType') this.commandType,
      @JsonKey(name: 'payload') this.payload});

  factory _$KioskCommandImpl.fromJson(Map<String, dynamic> json) =>
      _$$KioskCommandImplFromJson(json);

  @override
  @JsonKey(name: 'commandId')
  final String? commandId;
  @override
  @JsonKey(name: 'commandType')
  final String? commandType;
  @override
  @JsonKey(name: 'payload')
  final KioskCommandPayload? payload;

  @override
  String toString() {
    return 'KioskCommand(commandId: $commandId, commandType: $commandType, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KioskCommandImpl &&
            (identical(other.commandId, commandId) ||
                other.commandId == commandId) &&
            (identical(other.commandType, commandType) ||
                other.commandType == commandType) &&
            (identical(other.payload, payload) || other.payload == payload));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, commandId, commandType, payload);

  /// Create a copy of KioskCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KioskCommandImplCopyWith<_$KioskCommandImpl> get copyWith =>
      __$$KioskCommandImplCopyWithImpl<_$KioskCommandImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KioskCommandImplToJson(
      this,
    );
  }
}

abstract class _KioskCommand implements KioskCommand {
  const factory _KioskCommand(
          {@JsonKey(name: 'commandId') final String? commandId,
          @JsonKey(name: 'commandType') final String? commandType,
          @JsonKey(name: 'payload') final KioskCommandPayload? payload}) =
      _$KioskCommandImpl;

  factory _KioskCommand.fromJson(Map<String, dynamic> json) =
      _$KioskCommandImpl.fromJson;

  @override
  @JsonKey(name: 'commandId')
  String? get commandId;
  @override
  @JsonKey(name: 'commandType')
  String? get commandType;
  @override
  @JsonKey(name: 'payload')
  KioskCommandPayload? get payload;

  /// Create a copy of KioskCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KioskCommandImplCopyWith<_$KioskCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KioskCommandPayload _$KioskCommandPayloadFromJson(Map<String, dynamic> json) {
  return _KioskCommandPayload.fromJson(json);
}

/// @nodoc
mixin _$KioskCommandPayload {
  @JsonKey(name: 'imageUrl')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'printQuantity')
  int? get printQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'isCut')
  bool? get isCut => throw _privateConstructorUsedError;
  @JsonKey(name: 'orientation')
  String? get orientation => throw _privateConstructorUsedError;

  /// Serializes this KioskCommandPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KioskCommandPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KioskCommandPayloadCopyWith<KioskCommandPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KioskCommandPayloadCopyWith<$Res> {
  factory $KioskCommandPayloadCopyWith(
          KioskCommandPayload value, $Res Function(KioskCommandPayload) then) =
      _$KioskCommandPayloadCopyWithImpl<$Res, KioskCommandPayload>;
  @useResult
  $Res call(
      {@JsonKey(name: 'imageUrl') String? imageUrl,
      @JsonKey(name: 'printQuantity') int? printQuantity,
      @JsonKey(name: 'isCut') bool? isCut,
      @JsonKey(name: 'orientation') String? orientation});
}

/// @nodoc
class _$KioskCommandPayloadCopyWithImpl<$Res, $Val extends KioskCommandPayload>
    implements $KioskCommandPayloadCopyWith<$Res> {
  _$KioskCommandPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KioskCommandPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = freezed,
    Object? printQuantity = freezed,
    Object? isCut = freezed,
    Object? orientation = freezed,
  }) {
    return _then(_value.copyWith(
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      printQuantity: freezed == printQuantity
          ? _value.printQuantity
          : printQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      isCut: freezed == isCut
          ? _value.isCut
          : isCut // ignore: cast_nullable_to_non_nullable
              as bool?,
      orientation: freezed == orientation
          ? _value.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KioskCommandPayloadImplCopyWith<$Res>
    implements $KioskCommandPayloadCopyWith<$Res> {
  factory _$$KioskCommandPayloadImplCopyWith(_$KioskCommandPayloadImpl value,
          $Res Function(_$KioskCommandPayloadImpl) then) =
      __$$KioskCommandPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'imageUrl') String? imageUrl,
      @JsonKey(name: 'printQuantity') int? printQuantity,
      @JsonKey(name: 'isCut') bool? isCut,
      @JsonKey(name: 'orientation') String? orientation});
}

/// @nodoc
class __$$KioskCommandPayloadImplCopyWithImpl<$Res>
    extends _$KioskCommandPayloadCopyWithImpl<$Res, _$KioskCommandPayloadImpl>
    implements _$$KioskCommandPayloadImplCopyWith<$Res> {
  __$$KioskCommandPayloadImplCopyWithImpl(_$KioskCommandPayloadImpl _value,
      $Res Function(_$KioskCommandPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of KioskCommandPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = freezed,
    Object? printQuantity = freezed,
    Object? isCut = freezed,
    Object? orientation = freezed,
  }) {
    return _then(_$KioskCommandPayloadImpl(
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      printQuantity: freezed == printQuantity
          ? _value.printQuantity
          : printQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      isCut: freezed == isCut
          ? _value.isCut
          : isCut // ignore: cast_nullable_to_non_nullable
              as bool?,
      orientation: freezed == orientation
          ? _value.orientation
          : orientation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KioskCommandPayloadImpl implements _KioskCommandPayload {
  const _$KioskCommandPayloadImpl(
      {@JsonKey(name: 'imageUrl') this.imageUrl,
      @JsonKey(name: 'printQuantity') this.printQuantity,
      @JsonKey(name: 'isCut') this.isCut,
      @JsonKey(name: 'orientation') this.orientation});

  factory _$KioskCommandPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$KioskCommandPayloadImplFromJson(json);

  @override
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @override
  @JsonKey(name: 'printQuantity')
  final int? printQuantity;
  @override
  @JsonKey(name: 'isCut')
  final bool? isCut;
  @override
  @JsonKey(name: 'orientation')
  final String? orientation;

  @override
  String toString() {
    return 'KioskCommandPayload(imageUrl: $imageUrl, printQuantity: $printQuantity, isCut: $isCut, orientation: $orientation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KioskCommandPayloadImpl &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.printQuantity, printQuantity) ||
                other.printQuantity == printQuantity) &&
            (identical(other.isCut, isCut) || other.isCut == isCut) &&
            (identical(other.orientation, orientation) ||
                other.orientation == orientation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imageUrl, printQuantity, isCut, orientation);

  /// Create a copy of KioskCommandPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KioskCommandPayloadImplCopyWith<_$KioskCommandPayloadImpl> get copyWith =>
      __$$KioskCommandPayloadImplCopyWithImpl<_$KioskCommandPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KioskCommandPayloadImplToJson(
      this,
    );
  }
}

abstract class _KioskCommandPayload implements KioskCommandPayload {
  const factory _KioskCommandPayload(
          {@JsonKey(name: 'imageUrl') final String? imageUrl,
          @JsonKey(name: 'printQuantity') final int? printQuantity,
          @JsonKey(name: 'isCut') final bool? isCut,
          @JsonKey(name: 'orientation') final String? orientation}) =
      _$KioskCommandPayloadImpl;

  factory _KioskCommandPayload.fromJson(Map<String, dynamic> json) =
      _$KioskCommandPayloadImpl.fromJson;

  @override
  @JsonKey(name: 'imageUrl')
  String? get imageUrl;
  @override
  @JsonKey(name: 'printQuantity')
  int? get printQuantity;
  @override
  @JsonKey(name: 'isCut')
  bool? get isCut;
  @override
  @JsonKey(name: 'orientation')
  String? get orientation;

  /// Create a copy of KioskCommandPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KioskCommandPayloadImplCopyWith<_$KioskCommandPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
