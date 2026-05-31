import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/log/log_config.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/provider/app_state.dart';
import 'package:project_l/config/injetable_config.dart';

@LazySingleton()
class AppRouteObserver extends AutoRouteObserver with LogMixin {
  static const _enableLog = LogConfig.enableNavigatorObserverLog;

  AppState get _appState => getIt.get<AppState>();

  void _trackScreen(Route? route, String eventType) {
    final screenName = route?.settings.name ?? '';
    if (screenName.isEmpty) {
      return;
    }
    _appState.setCurrentScreen(screenName);
    unawaited(
      _appState.sendEvent(
        eventType: eventType,
        payload: {
          "screen": screenName,
          "route": route?.settings.name,
        },
      ),
    );
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (_enableLog) {
      logD(
          'didPush from ${previousRoute?.settings.name} to ${route.settings.name}');
    }
    _trackScreen(route, "SCREEN_PUSH");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (_enableLog) {
      logD(
          'didPop ${route.settings.name}, back to ${previousRoute?.settings.name}');
    }
    _trackScreen(previousRoute, "SCREEN_POP");
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (_enableLog) {
      logD(
          'didRemove ${route.settings.name}, back to ${previousRoute?.settings.name}');
    }
    _trackScreen(previousRoute, "SCREEN_REMOVE");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (_enableLog) {
      logD(
          'didReplace ${oldRoute?.settings.name} by ${newRoute?.settings.name}');
    }
    _trackScreen(newRoute, "SCREEN_REPLACE");
  }
}
