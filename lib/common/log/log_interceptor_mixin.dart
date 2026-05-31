import 'log_utils.dart';


mixin LogInterceptorMixin on Object {
  void logRequest(String message, {DateTime? time}) {
    LogUtils.d(message, name: runtimeType.toString(), time: time);
  }

  // void logResponse(dynamic message, {DateTime? time}) {
  //   if (message is Map) {
  //     LogUtils.printPrettyMap(message);
  //   } else if (message is String) {
  //     try {
  //       var map = jsonDecode(message);
  //       LogUtils.printPrettyMap(map);
  //     } catch (e) {
  //       LogUtils.d(message, time: time);
  //     }
  //   } else {
  //     LogUtils.d(message.toString(), name: runtimeType.toString(), time: time);
  //   }
  // }

  void logD(String message, {DateTime? time}) {
    LogUtils.d(message, name: runtimeType.toString(), time: time);
  }

  void logE(
    Object? errorMessage, {
    Object? clazz,
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    LogUtils.e(
      errorMessage,
      name: runtimeType.toString(),
      errorObject: errorObject,
      stackTrace: stackTrace,
      time: time,
    );
  }
}
