import 'dart:developer';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:project_l/common/log/log_utils.dart';

mixin LogMixin on Object {
  void logD(String message, {DateTime? time}) {
    LogUtils.d(message, name: runtimeType.toString(), time: time);
  }

  void logU(String message, {DateTime? time}) {
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

class MyConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(log);
  }
}

class FileLogOutput extends LogOutput {
  final File _logFile;

  FileLogOutput(this._logFile);

  @override
  void output(OutputEvent event) async {
    // Append logs to the file
    final logContent = '${event.lines.join('\n')}\n';
    await _logFile.writeAsString(logContent, mode: FileMode.append);
  }
}
