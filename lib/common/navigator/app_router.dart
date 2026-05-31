import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
@singleton
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: StandByRoute.page, initial: true),
        AutoRoute(page: CouponRoute.page),
        AutoRoute(page: SelectFilterRoute.page),
        AutoRoute(page: ChooseFrameRoute.page),
        AutoRoute(
          page: ChooseFrameQuantityRoute.page,
        ),
        AutoRoute(page: PaymentRouteRoute.page),
        AutoRoute(page: ShootingGuideRouteRoute.page),
        AutoRoute(
          page: ShootingRoute.page,
        ),
        AutoRoute(
          page: PhotoSelectionRoute.page,
        ),
        AutoRoute(
          page: BackgroundSelectionRoute.page,
        ),
        AutoRoute(
          page: PrintingRoute.page,
        ),
      ];
}
