// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:project_l/features/background_selection/background_selection.dart'
    as _i1;
import 'package:project_l/features/choose_frame/choose_frame.dart' as _i3;
import 'package:project_l/features/choose_frame_quantity/choose_frame_quantity.dart'
    as _i2;
import 'package:project_l/features/coupon_screen/coupon_screen.dart' as _i4;
import 'package:project_l/features/payment_screen/payment_screen.dart' as _i5;
import 'package:project_l/features/photo_selection/photo_selection_screen.dart'
    as _i6;
import 'package:project_l/features/printing/printing_screen.dart' as _i7;
import 'package:project_l/features/select_filter/select_filter_screen.dart'
    as _i8;
import 'package:project_l/features/shooting_guide_screen/shooting_guide_screen.dart'
    as _i9;
import 'package:project_l/features/shooting_screen/shooting_screen.dart'
    as _i10;
import 'package:project_l/features/stand_by/stand_by_screen.dart' as _i11;

/// generated route for
/// [_i1.BackgroundSelectionScreen]
class BackgroundSelectionRoute extends _i12.PageRouteInfo<void> {
  const BackgroundSelectionRoute({List<_i12.PageRouteInfo>? children})
    : super(BackgroundSelectionRoute.name, initialChildren: children);

  static const String name = 'BackgroundSelectionRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.BackgroundSelectionScreen();
    },
  );
}

/// generated route for
/// [_i2.ChooseFrameQuantityScreen]
class ChooseFrameQuantityRoute extends _i12.PageRouteInfo<void> {
  const ChooseFrameQuantityRoute({List<_i12.PageRouteInfo>? children})
    : super(ChooseFrameQuantityRoute.name, initialChildren: children);

  static const String name = 'ChooseFrameQuantityRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.ChooseFrameQuantityScreen();
    },
  );
}

/// generated route for
/// [_i3.ChooseFrameScreen]
class ChooseFrameRoute extends _i12.PageRouteInfo<void> {
  const ChooseFrameRoute({List<_i12.PageRouteInfo>? children})
    : super(ChooseFrameRoute.name, initialChildren: children);

  static const String name = 'ChooseFrameRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChooseFrameScreen();
    },
  );
}

/// generated route for
/// [_i4.CouponScreen]
class CouponRoute extends _i12.PageRouteInfo<void> {
  const CouponRoute({List<_i12.PageRouteInfo>? children})
    : super(CouponRoute.name, initialChildren: children);

  static const String name = 'CouponRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.CouponScreen();
    },
  );
}

/// generated route for
/// [_i5.PaymentScreenScreen]
class PaymentRouteRoute extends _i12.PageRouteInfo<PaymentRouteRouteArgs> {
  PaymentRouteRoute({
    _i13.Key? key,
    double totalPrice = 100000,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         PaymentRouteRoute.name,
         args: PaymentRouteRouteArgs(key: key, totalPrice: totalPrice),
         initialChildren: children,
       );

  static const String name = 'PaymentRouteRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentRouteRouteArgs>(
        orElse: () => const PaymentRouteRouteArgs(),
      );
      return _i5.PaymentScreenScreen(
        key: args.key,
        totalPrice: args.totalPrice,
      );
    },
  );
}

class PaymentRouteRouteArgs {
  const PaymentRouteRouteArgs({this.key, this.totalPrice = 100000});

  final _i13.Key? key;

  final double totalPrice;

  @override
  String toString() {
    return 'PaymentRouteRouteArgs{key: $key, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i6.PhotoSelectionScreen]
class PhotoSelectionRoute extends _i12.PageRouteInfo<PhotoSelectionRouteArgs> {
  PhotoSelectionRoute({
    _i13.Key? key,
    required Map<String, String> files,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         PhotoSelectionRoute.name,
         args: PhotoSelectionRouteArgs(key: key, files: files),
         initialChildren: children,
       );

  static const String name = 'PhotoSelectionRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhotoSelectionRouteArgs>();
      return _i6.PhotoSelectionScreen(key: args.key, files: args.files);
    },
  );
}

class PhotoSelectionRouteArgs {
  const PhotoSelectionRouteArgs({this.key, required this.files});

  final _i13.Key? key;

  final Map<String, String> files;

  @override
  String toString() {
    return 'PhotoSelectionRouteArgs{key: $key, files: $files}';
  }
}

/// generated route for
/// [_i7.PrintingScreen]
class PrintingRoute extends _i12.PageRouteInfo<PrintingRouteArgs> {
  PrintingRoute({
    _i13.Key? key,
    required List<_i13.TransformationController> transformationControllers,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         PrintingRoute.name,
         args: PrintingRouteArgs(
           key: key,
           transformationControllers: transformationControllers,
         ),
         initialChildren: children,
       );

  static const String name = 'PrintingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PrintingRouteArgs>();
      return _i7.PrintingScreen(
        key: args.key,
        transformationControllers: args.transformationControllers,
      );
    },
  );
}

class PrintingRouteArgs {
  const PrintingRouteArgs({this.key, required this.transformationControllers});

  final _i13.Key? key;

  final List<_i13.TransformationController> transformationControllers;

  @override
  String toString() {
    return 'PrintingRouteArgs{key: $key, transformationControllers: $transformationControllers}';
  }
}

/// generated route for
/// [_i8.SelectFilterScreen]
class SelectFilterRoute extends _i12.PageRouteInfo<void> {
  const SelectFilterRoute({List<_i12.PageRouteInfo>? children})
    : super(SelectFilterRoute.name, initialChildren: children);

  static const String name = 'SelectFilterRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.SelectFilterScreen();
    },
  );
}

/// generated route for
/// [_i9.ShootingGuideScreenScreen]
class ShootingGuideRouteRoute extends _i12.PageRouteInfo<void> {
  const ShootingGuideRouteRoute({List<_i12.PageRouteInfo>? children})
    : super(ShootingGuideRouteRoute.name, initialChildren: children);

  static const String name = 'ShootingGuideRouteRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.ShootingGuideScreenScreen();
    },
  );
}

/// generated route for
/// [_i10.ShootingScreen]
class ShootingRoute extends _i12.PageRouteInfo<void> {
  const ShootingRoute({List<_i12.PageRouteInfo>? children})
    : super(ShootingRoute.name, initialChildren: children);

  static const String name = 'ShootingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.ShootingScreen();
    },
  );
}

/// generated route for
/// [_i11.StandByScreen]
class StandByRoute extends _i12.PageRouteInfo<void> {
  const StandByRoute({List<_i12.PageRouteInfo>? children})
    : super(StandByRoute.name, initialChildren: children);

  static const String name = 'StandByRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.StandByScreen();
    },
  );
}
