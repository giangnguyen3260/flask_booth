class LogConfig {
  const LogConfig._();
  static const enableGeneralLog = true;
  static const isPrettyJson = true;
  static const isPrettyArray = true;
  static const exportLogFile = true;

  /// bloc observer
  static const logOnBlocChange = true;
  static const logOnBlocCreate = true;
  static const logOnBlocClose = true;
  static const logOnBlocError = true;
  static const logOnBlocEvent = true;
  static const logOnBlocTransition = true;

  /// navigator observer
  static const enableNavigatorObserverLog = true;

  /// disposeBag
  static const enableDisposeBagLog = true;

  /// stream event log
  static const logOnStreamListen = true;
  static const logOnStreamData = true;
  static const logOnStreamError = true;
  static const logOnStreamDone = true;
  static const logOnStreamCancel = true;

  /// log interceptor
  static const enableLogInterceptor = true;
  static const enableLogRequestInfo = true;
  static const enableLogSuccessResponse = true;
  static const enableLogErrorResponse = true;

  /// enable log usecase
  static const enableLogUseCaseInput = true;
  static const enableLogUseCaseOutput = true;
  static const enableLogUseCaseError = true;
}
