import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/constants/device_constants.dart';
import 'package:project_l/common/log/log_utils.dart';
import 'package:project_l/common/navigator/app_router.dart';
import 'package:project_l/common/provider/app_state.dart';
import 'package:project_l/config/injetable_config.dart';
import 'package:project_l/common/models/app_theme_config.dart';
import 'package:project_l/resources/app_theme_data.dart';
import 'package:project_l/resources/app_theme_palette.dart';
import 'package:project_l/resources/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'common/navigator/app_route_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  WindowOptions windowOptions = const WindowOptions(
    alwaysOnTop: false,
    fullScreen: true,
    center: true,
  );
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(windowOptions);
  await LogUtils.initialize();

  LogUtils.d("Start");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState appState = getIt.get<AppState>();

  @override
  void initState() {
    appState.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.cameraUtils.initSdk();
    });
    super.initState();
  }

  @override
  void dispose() {
    appState.cameraUtils.terminateSdk();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: Selector<AppState, Locale>(
        selector: (context, provider) => provider.locate,
        builder: (context, Locale value, child) {
          return Selector<AppState, AppThemeConfig>(
            selector: (context, provider) => provider.themeConfig,
            builder: (context, themeConfig, child) {
              AppThemePalette.apply(themeConfig);
              return ScreenUtilInit(
                designSize: const Size(DeviceConstants.designDeviceWidth,
                    DeviceConstants.designDeviceHeight),
                minTextAdapt: true,
                splitScreenMode: true,
                child: MaterialApp.router(
                  scrollBehavior: MyCustomScrollBehavior(),
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: buildAppThemeData(),
                  localeResolutionCallback:
                      (Locale? locale, Iterable<Locale> supportedLocales) {
                    return supportedLocales.contains(locale)
                        ? locale
                        : const Locale('en');
                  },
                  locale: value,
                  supportedLocales: S.delegate.supportedLocales,
                  routerConfig: getIt.get<AppRouter>().config(
                    navigatorObservers: () => [
                      getIt.get<AppRouteObserver>(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
