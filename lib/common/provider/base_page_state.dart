import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/navigator/app_router.dart';
import 'package:project_l/common/provider/app_state.dart';
import 'package:project_l/common/provider/base_listen_state.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/config/injetable_config.dart';
import 'package:project_l/gen/assets.gen.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/components/common_counter.dart';
import 'package:project_l/resources/generated/l10n.dart';
import 'package:provider/provider.dart';

abstract class BasePageState<L extends BaseListenState,
        P extends BaseProvider<L>, T extends StatefulWidget> extends State<T>
    with LogMixin, AutoRouteAwareStateMixin<T> {
  P? _provider;

  P get provider => _provider!;

  late final navigator = getIt.get<AppRouter>();
  late final appState = getIt.get<AppState>();
  late Timer timer;
  int remainingTime = 0;
  double progress = 1.0;

  late final CommonCounterController countDown =
      CommonCounterController(defaultTime: countDuration());

  int getCounterAtIndex(int index) {
    var timer = (appState.appData.configInfo?.timer ?? [])
            .elementAtOrNull(index)
            ?.value ??
        120;
    return timer;
  }

  void resetTimer() {
    countDown.reset();
  }

  @override
  void dispose() {
    countDown.stop();
    countDown.dispose();
    super.dispose();
  }

  bool isShowNext(P provider) {
    return false;
  }

  @override
  void didPopNext() {
    if (isShowCountDown()) {
      countDown.resume();
    }
    super.didPopNext();
  }

  @override
  void didPushNext() {
    if (isShowCountDown()) {
      countDown.stop();
    }
    super.didPushNext();
  }

  @mustCallSuper
  void onNext(P provider) {
    try {
      countDown.stop();
    } catch (e) {
      //
    }
  }

  Widget renderFooter(P provider) {
    return SizedBox.shrink();
  }

  bool allowToBack(P provider) {
    return true;
  }

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      afterFirstBuild();
      provider.stream.listen((event) {
        listenState(event);
      });

      if (isShowCountDown()) {
        countDown.addListener(() {
          if (countDown.currentCounter <= 1) {
            onTimeEnd();
          }
        });
        countDown.start();
      }
    });
  }

  bool isShowCountDown() {
    return true;
  }

  bool isFooterEnabled() => true;

  int countDuration() {
    return 120;
  }

  void onTimeEnd() {
    if (isShowCountDown()) {
      navigator.pop();
    } else {}
  }

  Widget renderNextBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Tiếp tục",
            style: style32500,
          ),
          10.horizontalSpace,
          Icon(
            color: Colors.white,
            Icons.arrow_right,
            size: style32500.fontSize?.r,
          )
        ],
      ),
    );
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double maxWidth = size.width;
    double maxHeight = size.height;
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (ctx) => getIt.get<P>(),
        child: Builder(
          builder: (ctx) {
            _provider ??= Provider.of<P>(ctx);
            return SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: Stack(
                children: [
                  Center(
                    child: Selector<AppState, String>(
                      selector: (_, appState) => appState.locate.languageCode,
                      builder: (_, __, ___) =>
                          buildPage(ctx, maxWidth, maxHeight),
                    ),
                  ),
                  Visibility(
                    visible: navigator.canPop() && allowToBack(provider),
                    child: Padding(
                      padding: EdgeInsets.all(48.h),
                      child: OutlinedButton(
                        onPressed: () {
                          navigator.pop();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Assets.icons.arrowLeftRounded.svg(width: 24.w),
                            12.horizontalSpace,
                            Text(
                              S.of(context).btn_back,
                              style: style32500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: maxWidth - 126.w - 38.w * 2 - 3.w,
                    child: Visibility(
                      visible: isShowCountDown(),
                      replacement: SizedBox.shrink(),
                      child: Padding(
                        padding: EdgeInsets.all(38.r),
                        child: CommonCounter(
                          controller: countDown,
                          backgroundColor: Colors.black,
                        ),
                        // child: _renderCountDown(),
                      ),
                    ),
                  ),
                  isFooterEnabled()
                      ? Positioned(
                          left: maxWidth - 227.w - 48.w,
                          top: maxHeight - 80.h - 48.h,
                          child: Visibility(
                            visible: isShowNext(provider),
                            child: ElevatedButton(
                              onPressed: () {
                                onNext(provider);
                              },
                              child: renderNextBtn(),
                            ),
                          ))
                      : SizedBox.shrink()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context, double maxWidth, double maxHeight);

  void listenState(L event) {}

  void afterFirstBuild() {}
}
