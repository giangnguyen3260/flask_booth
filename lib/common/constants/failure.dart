abstract class Failure {
  String? message;

  Failure({this.message});

  @override
  String toString() {
    return 'App Failure: {kind: $runtimeType, meg: }';
  }
}

class ServerError extends Failure {
  final String? errorCode;

  ServerError({super.message, this.errorCode});
}

class ManualCancel extends Failure {
  ManualCancel({super.message});
}

class FeatureCancel extends Failure {
  final String? reason;

  FeatureCancel({super.message, this.reason});
}

class InternalError extends Failure {
  InternalError({super.message});
}

class UnCatchingError extends Failure {
  UnCatchingError({super.message});
}

class DataNotFound extends Failure {
  DataNotFound({super.message});
}

class FeatureError extends Failure {
  String? errorCode;
  String? errorMsgCode;

  FeatureError({
    super.message,
    this.errorCode,
    this.errorMsgCode,
  });
}

class PrinterError extends Failure {
  PrinterError({super.message});
}
