// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImageParam {
  String get session => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<String> get videos => throw _privateConstructorUsedError;
  bool get isFlipped => throw _privateConstructorUsedError;
  FramesInfo get selectedFrame => throw _privateConstructorUsedError;
  Background get selectedBackground => throw _privateConstructorUsedError;
  List<MatrixParam> get pansAndScales => throw _privateConstructorUsedError;
  ColorFilterGenerator? get colorFilter => throw _privateConstructorUsedError;
  Effect? get effect => throw _privateConstructorUsedError;
  int get printQuantity => throw _privateConstructorUsedError;
  String? get couponCode => throw _privateConstructorUsedError;

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageParamCopyWith<ImageParam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageParamCopyWith<$Res> {
  factory $ImageParamCopyWith(
          ImageParam value, $Res Function(ImageParam) then) =
      _$ImageParamCopyWithImpl<$Res, ImageParam>;
  @useResult
  $Res call(
      {String session,
      List<String> images,
      List<String> videos,
      bool isFlipped,
      FramesInfo selectedFrame,
      Background selectedBackground,
      List<MatrixParam> pansAndScales,
      ColorFilterGenerator? colorFilter,
      Effect? effect,
      int printQuantity,
      String? couponCode});

  $FramesInfoCopyWith<$Res> get selectedFrame;
  $BackgroundCopyWith<$Res> get selectedBackground;
  $EffectCopyWith<$Res>? get effect;
}

/// @nodoc
class _$ImageParamCopyWithImpl<$Res, $Val extends ImageParam>
    implements $ImageParamCopyWith<$Res> {
  _$ImageParamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? images = null,
    Object? videos = null,
    Object? isFlipped = null,
    Object? selectedFrame = null,
    Object? selectedBackground = null,
    Object? pansAndScales = null,
    Object? colorFilter = freezed,
    Object? effect = freezed,
    Object? printQuantity = null,
    Object? couponCode = freezed,
  }) {
    return _then(_value.copyWith(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videos: null == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFlipped: null == isFlipped
          ? _value.isFlipped
          : isFlipped // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedFrame: null == selectedFrame
          ? _value.selectedFrame
          : selectedFrame // ignore: cast_nullable_to_non_nullable
              as FramesInfo,
      selectedBackground: null == selectedBackground
          ? _value.selectedBackground
          : selectedBackground // ignore: cast_nullable_to_non_nullable
              as Background,
      pansAndScales: null == pansAndScales
          ? _value.pansAndScales
          : pansAndScales // ignore: cast_nullable_to_non_nullable
              as List<MatrixParam>,
      colorFilter: freezed == colorFilter
          ? _value.colorFilter
          : colorFilter // ignore: cast_nullable_to_non_nullable
              as ColorFilterGenerator?,
      effect: freezed == effect
          ? _value.effect
          : effect // ignore: cast_nullable_to_non_nullable
              as Effect?,
      printQuantity: null == printQuantity
          ? _value.printQuantity
          : printQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FramesInfoCopyWith<$Res> get selectedFrame {
    return $FramesInfoCopyWith<$Res>(_value.selectedFrame, (value) {
      return _then(_value.copyWith(selectedFrame: value) as $Val);
    });
  }

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BackgroundCopyWith<$Res> get selectedBackground {
    return $BackgroundCopyWith<$Res>(_value.selectedBackground, (value) {
      return _then(_value.copyWith(selectedBackground: value) as $Val);
    });
  }

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EffectCopyWith<$Res>? get effect {
    if (_value.effect == null) {
      return null;
    }

    return $EffectCopyWith<$Res>(_value.effect!, (value) {
      return _then(_value.copyWith(effect: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImageParamImplCopyWith<$Res>
    implements $ImageParamCopyWith<$Res> {
  factory _$$ImageParamImplCopyWith(
          _$ImageParamImpl value, $Res Function(_$ImageParamImpl) then) =
      __$$ImageParamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String session,
      List<String> images,
      List<String> videos,
      bool isFlipped,
      FramesInfo selectedFrame,
      Background selectedBackground,
      List<MatrixParam> pansAndScales,
      ColorFilterGenerator? colorFilter,
      Effect? effect,
      int printQuantity,
      String? couponCode});

  @override
  $FramesInfoCopyWith<$Res> get selectedFrame;
  @override
  $BackgroundCopyWith<$Res> get selectedBackground;
  @override
  $EffectCopyWith<$Res>? get effect;
}

/// @nodoc
class __$$ImageParamImplCopyWithImpl<$Res>
    extends _$ImageParamCopyWithImpl<$Res, _$ImageParamImpl>
    implements _$$ImageParamImplCopyWith<$Res> {
  __$$ImageParamImplCopyWithImpl(
      _$ImageParamImpl _value, $Res Function(_$ImageParamImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? images = null,
    Object? videos = null,
    Object? isFlipped = null,
    Object? selectedFrame = null,
    Object? selectedBackground = null,
    Object? pansAndScales = null,
    Object? colorFilter = freezed,
    Object? effect = freezed,
    Object? printQuantity = null,
    Object? couponCode = freezed,
  }) {
    return _then(_$ImageParamImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videos: null == videos
          ? _value._videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFlipped: null == isFlipped
          ? _value.isFlipped
          : isFlipped // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedFrame: null == selectedFrame
          ? _value.selectedFrame
          : selectedFrame // ignore: cast_nullable_to_non_nullable
              as FramesInfo,
      selectedBackground: null == selectedBackground
          ? _value.selectedBackground
          : selectedBackground // ignore: cast_nullable_to_non_nullable
              as Background,
      pansAndScales: null == pansAndScales
          ? _value._pansAndScales
          : pansAndScales // ignore: cast_nullable_to_non_nullable
              as List<MatrixParam>,
      colorFilter: freezed == colorFilter
          ? _value.colorFilter
          : colorFilter // ignore: cast_nullable_to_non_nullable
              as ColorFilterGenerator?,
      effect: freezed == effect
          ? _value.effect
          : effect // ignore: cast_nullable_to_non_nullable
              as Effect?,
      printQuantity: null == printQuantity
          ? _value.printQuantity
          : printQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ImageParamImpl implements _ImageParam {
  const _$ImageParamImpl(
      {this.session = "",
      final List<String> images = const [],
      final List<String> videos = const [],
      this.isFlipped = false,
      this.selectedFrame = const FramesInfo(),
      this.selectedBackground = const Background(),
      final List<MatrixParam> pansAndScales = const [],
      this.colorFilter,
      this.effect,
      this.printQuantity = 0,
      this.couponCode})
      : _images = images,
        _videos = videos,
        _pansAndScales = pansAndScales;

  @override
  @JsonKey()
  final String session;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String> _videos;
  @override
  @JsonKey()
  List<String> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  @override
  @JsonKey()
  final bool isFlipped;
  @override
  @JsonKey()
  final FramesInfo selectedFrame;
  @override
  @JsonKey()
  final Background selectedBackground;
  final List<MatrixParam> _pansAndScales;
  @override
  @JsonKey()
  List<MatrixParam> get pansAndScales {
    if (_pansAndScales is EqualUnmodifiableListView) return _pansAndScales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pansAndScales);
  }

  @override
  final ColorFilterGenerator? colorFilter;
  @override
  final Effect? effect;
  @override
  @JsonKey()
  final int printQuantity;
  @override
  final String? couponCode;

  @override
  String toString() {
    return 'ImageParam(session: $session, images: $images, videos: $videos, isFlipped: $isFlipped, selectedFrame: $selectedFrame, selectedBackground: $selectedBackground, pansAndScales: $pansAndScales, colorFilter: $colorFilter, effect: $effect, printQuantity: $printQuantity, couponCode: $couponCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageParamImpl &&
            (identical(other.session, session) || other.session == session) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._videos, _videos) &&
            (identical(other.isFlipped, isFlipped) ||
                other.isFlipped == isFlipped) &&
            (identical(other.selectedFrame, selectedFrame) ||
                other.selectedFrame == selectedFrame) &&
            (identical(other.selectedBackground, selectedBackground) ||
                other.selectedBackground == selectedBackground) &&
            const DeepCollectionEquality()
                .equals(other._pansAndScales, _pansAndScales) &&
            (identical(other.colorFilter, colorFilter) ||
                other.colorFilter == colorFilter) &&
            (identical(other.effect, effect) || other.effect == effect) &&
            (identical(other.printQuantity, printQuantity) ||
                other.printQuantity == printQuantity) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      session,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_videos),
      isFlipped,
      selectedFrame,
      selectedBackground,
      const DeepCollectionEquality().hash(_pansAndScales),
      colorFilter,
      effect,
      printQuantity,
      couponCode);

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageParamImplCopyWith<_$ImageParamImpl> get copyWith =>
      __$$ImageParamImplCopyWithImpl<_$ImageParamImpl>(this, _$identity);
}

abstract class _ImageParam implements ImageParam {
  const factory _ImageParam(
      {final String session,
      final List<String> images,
      final List<String> videos,
      final bool isFlipped,
      final FramesInfo selectedFrame,
      final Background selectedBackground,
      final List<MatrixParam> pansAndScales,
      final ColorFilterGenerator? colorFilter,
      final Effect? effect,
      final int printQuantity,
      final String? couponCode}) = _$ImageParamImpl;

  @override
  String get session;
  @override
  List<String> get images;
  @override
  List<String> get videos;
  @override
  bool get isFlipped;
  @override
  FramesInfo get selectedFrame;
  @override
  Background get selectedBackground;
  @override
  List<MatrixParam> get pansAndScales;
  @override
  ColorFilterGenerator? get colorFilter;
  @override
  Effect? get effect;
  @override
  int get printQuantity;
  @override
  String? get couponCode;

  /// Create a copy of ImageParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageParamImplCopyWith<_$ImageParamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
