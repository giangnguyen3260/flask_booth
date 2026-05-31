import 'package:logging/logging.dart';

class LogsConstants {
  const LogsConstants._();
  static final logger = Logger('P5k');
  static const int maxLogFileSize = 1024 * 1024; // 1MB
  static const bool printTime = true;
}
