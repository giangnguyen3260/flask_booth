import 'dart:io';

import 'package:flutter/foundation.dart';

const defaultBaseUrl = 'http://116.109.110.35:8080/api/v1';

String resolveBaseUrl() {
  final value = Platform.environment['PTB_BASE_URL'];
  if (value != null && value.trim().isNotEmpty) {
    return value.trim();
  }
  if (!kReleaseMode &&
      (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    return 'http://127.0.0.1:8080';
  }
  return defaultBaseUrl;
}
