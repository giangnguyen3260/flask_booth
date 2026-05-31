// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../common/navigator/app_route_observer.dart' as _i332;
import '../common/navigator/app_router.dart' as _i900;
import '../common/provider/app_state.dart' as _i835;
import '../common/remote/network_interceptor.dart' as _i599;
import '../common/remote/network_provider.dart' as _i151;
import '../common/util/background_mask_utils.dart' as _i1043;
import '../common/util/bill_acceptor_utils.dart' as _i483;
import '../common/util/camera_power_util.dart' as _i382;
import '../common/util/camera_utils.dart' as _i374;
import '../common/util/ffmpeg_utils.dart' as _i749;
import '../common/util/frame_overlay_mask_utils.dart' as _i163;
import '../common/util/printer_utils.dart' as _i644;
import '../common/util/qr_utils.dart' as _i203;
import '../common/util/remote_image_utils.dart' as _i1016;
import '../features/background_selection/provider/background_selection_provider.dart'
    as _i782;
import '../features/choose_frame/provider/choose_frame_provider.dart' as _i109;
import '../features/choose_frame_quantity/provider/choose_frame_quantity_provider.dart'
    as _i258;
import '../features/coupon_screen/provider/coupon_provider.dart' as _i561;
import '../features/payment_screen/provider/payment_screen_provider.dart'
    as _i817;
import '../features/photo_selection/provider/photo_selection_screen_provider.dart'
    as _i836;
import '../features/printing/provider/printing_screen_provider.dart' as _i1;
import '../features/select_filter/provider/select_filter_provider.dart'
    as _i832;
import '../features/shooting_guide_screen/provider/shooting_guide_screen_provider.dart'
    as _i125;
import '../features/shooting_screen/provider/shooting_screen_provider.dart'
    as _i643;
import '../features/stand_by/provider/stand_by_provider.dart' as _i107;
import '../remote/service/app_service.dart' as _i81;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i374.CameraUtils>(() => _i374.CameraUtils());
    gh.factory<_i836.PhotoSelectionProvider>(
        () => _i836.PhotoSelectionProvider());
    gh.factory<_i125.ShootingGuideScreenProvider>(
        () => _i125.ShootingGuideScreenProvider());
    gh.factory<_i782.BackgroundSelectionProvider>(
        () => _i782.BackgroundSelectionProvider());
    gh.factory<_i832.SelectFilterProvider>(() => _i832.SelectFilterProvider());
    gh.factory<_i109.ChooseFrameProvider>(() => _i109.ChooseFrameProvider());
    gh.factory<_i258.ChooseFrameQuantityProvider>(
        () => _i258.ChooseFrameQuantityProvider());
    gh.factory<_i107.StandByProvider>(() => _i107.StandByProvider());
    gh.factory<_i561.CouponProvider>(() => _i561.CouponProvider());
    gh.factory<_i203.QrUtils>(() => _i203.QrUtils());
    gh.factory<_i1016.RemoteImageUtils>(() => _i1016.RemoteImageUtils());
    gh.factory<_i599.NetworkInterceptor>(() => _i599.NetworkInterceptor());
    gh.singleton<_i483.BillAcceptorUtils>(() => _i483.BillAcceptorUtils());
    gh.singleton<_i644.PrinterUtils>(() => _i644.PrinterUtils());
    gh.singleton<_i1043.BackgroundMaskUtils>(
        () => _i1043.BackgroundMaskUtils());
    gh.singleton<_i382.CameraPowerUtil>(() => _i382.CameraPowerUtil());
    gh.singleton<_i163.FrameOverlayMaskUtils>(
        () => _i163.FrameOverlayMaskUtils());
    gh.singleton<_i749.FfmpegUtils>(() => _i749.FfmpegUtils());
    gh.singleton<_i900.AppRouter>(() => _i900.AppRouter());
    gh.lazySingleton<_i332.AppRouteObserver>(() => _i332.AppRouteObserver());
    gh.factory<_i151.NetworkProvider>(() => _i151.NetworkProvider(
        networkInterceptor: gh<_i599.NetworkInterceptor>()));
    gh.singleton<_i81.RestClient>(
        () => _i81.RestClient(gh<_i151.NetworkProvider>()));
    gh.factory<_i643.ShootingScreenProvider>(
        () => _i643.ShootingScreenProvider(gh<_i749.FfmpegUtils>()));
    gh.factory<_i1.PrintingScreenProvider>(() => _i1.PrintingScreenProvider(
          gh<_i749.FfmpegUtils>(),
          gh<_i644.PrinterUtils>(),
          gh<_i203.QrUtils>(),
        ));
    gh.factory<_i817.PaymentScreenProvider>(() => _i817.PaymentScreenProvider(
          gh<_i483.BillAcceptorUtils>(),
          gh<_i382.CameraPowerUtil>(),
        ));
    gh.singleton<_i835.AppState>(() => _i835.AppState(
          restClient: gh<_i81.RestClient>(),
          remoteImageUtils: gh<_i1016.RemoteImageUtils>(),
          networkProvider: gh<_i151.NetworkProvider>(),
        ));
    return this;
  }
}
