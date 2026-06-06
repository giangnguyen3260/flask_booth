import 'dart:io';

const defaultBaseUrl =
    'https://servers-zoloft-broken-crawford.trycloudflare.com';

String resolveBaseUrl() {
  final value = Platform.environment['PTB_BASE_URL'];
  if (value != null && value.trim().isNotEmpty) {
    return value.trim();
  }
  return defaultBaseUrl;
}
