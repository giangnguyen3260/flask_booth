// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shooting_screen_listen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShootingScreenListenState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShootingScreenSuccessState value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShootingScreenSuccessState value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShootingScreenSuccessState value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShootingScreenListenStateCopyWith<$Res> {
  factory $ShootingScreenListenStateCopyWith(ShootingScreenListenState value,
          $Res Function(ShootingScreenListenState) then) =
      _$ShootingScreenListenStateCopyWithImpl<$Res, ShootingScreenListenState>;
}

/// @nodoc
class _$ShootingScreenListenStateCopyWithImpl<$Res,
        $Val extends ShootingScreenListenState>
    implements $ShootingScreenListenStateCopyWith<$Res> {
  _$ShootingScreenListenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShootingScreenListenState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ShootingScreenSuccessStateImplCopyWith<$Res> {
  factory _$$ShootingScreenSuccessStateImplCopyWith(
          _$ShootingScreenSuccessStateImpl value,
          $Res Function(_$ShootingScreenSuccessStateImpl) then) =
      __$$ShootingScreenSuccessStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShootingScreenSuccessStateImplCopyWithImpl<$Res>
    extends _$ShootingScreenListenStateCopyWithImpl<$Res,
        _$ShootingScreenSuccessStateImpl>
    implements _$$ShootingScreenSuccessStateImplCopyWith<$Res> {
  __$$ShootingScreenSuccessStateImplCopyWithImpl(
      _$ShootingScreenSuccessStateImpl _value,
      $Res Function(_$ShootingScreenSuccessStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShootingScreenListenState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ShootingScreenSuccessStateImpl implements ShootingScreenSuccessState {
  const _$ShootingScreenSuccessStateImpl();

  @override
  String toString() {
    return 'ShootingScreenListenState.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShootingScreenSuccessStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() success,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? success,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShootingScreenSuccessState value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShootingScreenSuccessState value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShootingScreenSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class ShootingScreenSuccessState implements ShootingScreenListenState {
  const factory ShootingScreenSuccessState() = _$ShootingScreenSuccessStateImpl;
}
