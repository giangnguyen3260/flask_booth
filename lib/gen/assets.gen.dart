/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:lottie/lottie.dart' as _lottie;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsDummyGen {
  const $AssetsDummyGen();

  /// File path: assets/dummy/photobooth_info.json
  String get photoboothInfo => 'assets/dummy/photobooth_info.json';

  /// List of all assets
  List<String> get values => [photoboothInfo];
}

class $AssetsFilesGen {
  const $AssetsFilesGen();

  /// File path: assets/files/2inch_cut.dat
  String get a2inchCut => 'assets/files/2inch_cut.dat';

  /// File path: assets/files/filter.txt
  String get filter => 'assets/files/filter.txt';

  /// File path: assets/files/glfw3.dll
  String get glfw3 => 'assets/files/glfw3.dll';

  /// File path: assets/files/main.exe
  String get main => 'assets/files/main.exe';

  /// File path: assets/files/msvcr120.dll
  String get msvcr120 => 'assets/files/msvcr120.dll';

  /// File path: assets/files/normal_cut.dat
  String get normalCut => 'assets/files/normal_cut.dat';

  /// List of all assets
  List<String> get values => [
    a2inchCut,
    filter,
    glfw3,
    main,
    msvcr120,
    normalCut,
  ];
}

class $AssetsFrameGen {
  const $AssetsFrameGen();

  /// File path: assets/frame/frame_3_vertical.png
  AssetGenImage get frame3Vertical =>
      const AssetGenImage('assets/frame/frame_3_vertical.png');

  /// File path: assets/frame/frame_4_horizontal.png
  AssetGenImage get frame4Horizontal =>
      const AssetGenImage('assets/frame/frame_4_horizontal.png');

  /// File path: assets/frame/frame_4_vertical.png
  AssetGenImage get frame4Vertical =>
      const AssetGenImage('assets/frame/frame_4_vertical.png');

  /// File path: assets/frame/frame_6_vertical.png
  AssetGenImage get frame6Vertical =>
      const AssetGenImage('assets/frame/frame_6_vertical.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    frame3Vertical,
    frame4Horizontal,
    frame4Vertical,
    frame6Vertical,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow_left_rounded.svg
  SvgGenImage get arrowLeftRounded =>
      const SvgGenImage('assets/icons/arrow_left_rounded.svg');

  /// File path: assets/icons/arrow_right_rounded.svg
  SvgGenImage get arrowRightRounded =>
      const SvgGenImage('assets/icons/arrow_right_rounded.svg');

  /// File path: assets/icons/arrow_up_ic.svg
  SvgGenImage get arrowUpIc =>
      const SvgGenImage('assets/icons/arrow_up_ic.svg');

  /// File path: assets/icons/bell.svg
  SvgGenImage get bell => const SvgGenImage('assets/icons/bell.svg');

  /// File path: assets/icons/camera_ic.svg
  SvgGenImage get cameraIc => const SvgGenImage('assets/icons/camera_ic.svg');

  /// File path: assets/icons/discount_ic.svg
  SvgGenImage get discountIc =>
      const SvgGenImage('assets/icons/discount_ic.svg');

  /// File path: assets/icons/flip_ic.svg
  SvgGenImage get flipIc => const SvgGenImage('assets/icons/flip_ic.svg');

  /// File path: assets/icons/mouse_click_stand_by_ic.svg
  SvgGenImage get mouseClickStandByIc =>
      const SvgGenImage('assets/icons/mouse_click_stand_by_ic.svg');

  /// File path: assets/icons/redo_ic.svg
  SvgGenImage get redoIc => const SvgGenImage('assets/icons/redo_ic.svg');

  /// File path: assets/icons/shooting_ic.svg
  SvgGenImage get shootingIc =>
      const SvgGenImage('assets/icons/shooting_ic.svg');

  /// File path: assets/icons/timing_ic.svg
  SvgGenImage get timingIc => const SvgGenImage('assets/icons/timing_ic.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    arrowLeftRounded,
    arrowRightRounded,
    arrowUpIc,
    bell,
    cameraIc,
    discountIc,
    flipIc,
    mouseClickStandByIc,
    redoIc,
    shootingIc,
    timingIc,
  ];
}

class $AssetsLottiesGen {
  const $AssetsLottiesGen();

  /// File path: assets/lotties/loading.json
  LottieGenImage get loading =>
      const LottieGenImage('assets/lotties/loading.json');

  /// List of all assets
  List<LottieGenImage> get values => [loading];
}

class Assets {
  const Assets._();

  static const $AssetsDummyGen dummy = $AssetsDummyGen();
  static const $AssetsFilesGen files = $AssetsFilesGen();
  static const $AssetsFrameGen frame = $AssetsFrameGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class LottieGenImage {
  const LottieGenImage(this._assetName, {this.flavors = const {}});

  final String _assetName;
  final Set<String> flavors;

  _lottie.LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    _lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    _lottie.LottieDelegates? delegates,
    _lottie.LottieOptions? options,
    void Function(_lottie.LottieComposition)? onLoaded,
    _lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, _lottie.LottieComposition?)?
    frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    _lottie.LottieDecoder? decoder,
    _lottie.RenderCache? renderCache,
    bool? backgroundLoading,
  }) {
    return _lottie.Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
      decoder: decoder,
      renderCache: renderCache,
      backgroundLoading: backgroundLoading,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
