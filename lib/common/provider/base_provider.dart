import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/navigator/app_router.dart';
import 'package:project_l/common/provider/app_state.dart';
import 'package:project_l/common/provider/base_listen_state.dart';
import 'package:project_l/config/injetable_config.dart';
import 'package:project_l/remote/service/app_service.dart';

abstract class BaseProvider<L extends BaseListenState> extends ChangeNotifier with LogMixin{
  final StreamController<L> streamController = StreamController<L>.broadcast();

  Stream<L> get stream => streamController.stream;

  late final AppState appState = getIt.get();
  late final navigator = getIt.get<AppRouter>();
  late final RestClient appService = getIt.get();

  BaseProvider();
}
