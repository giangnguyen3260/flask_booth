import 'dart:io';

const defaultBaseUrl =
    'https://flashybooth.store';

String resolveBaseUrl() {
  final value = Platform.environment['PTB_BASE_URL'];
  if (value != null && value.trim().isNotEmpty) {
    return value.trim();
  }
  return defaultBaseUrl;
}
