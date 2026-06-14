import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/constants/remote.dart';

import '../constants/network_constants.dart';
import 'app_network_provider.dart';
import 'network_interceptor.dart';

@Injectable()
class NetworkProvider extends AppNetworkProvider {
  final NetworkInterceptor networkInterceptor;

  NetworkProvider({
    required this.networkInterceptor,
  });

  @override
  void addInterceptor() {
    appDio.interceptors.add(networkInterceptor);
  }

  @override
  void init() {
    appDio.options = BaseOptions(
      baseUrl: getBaseUrl(),
      connectTimeout: const Duration(seconds: NetworkConstants.timeoutSeconds),
      receiveTimeout: const Duration(seconds: NetworkConstants.timeoutSeconds),
      sendTimeout: const Duration(seconds: NetworkConstants.timeoutSeconds),
      contentType: NetworkConstants.jsonContentType,
    );
  }

  @override
  String getBaseUrl() {
    return resolveBaseUrl();
  }

  void setBaseUrl(String value) {
    if (value.trim().isEmpty) {
      return;
    }
    appDio.options = appDio.options.copyWith(baseUrl: value.trim());
  }

  void setKioskCredentials(String kioskCode, String kioskSecret) {
    if (kioskCode.trim().isEmpty || kioskSecret.trim().isEmpty) {
      return;
    }
    appDio.options = appDio.options.copyWith(
      headers: {
        ...appDio.options.headers,
        'X-Kiosk-Code': kioskCode.trim(),
        'X-Kiosk-Secret': kioskSecret.trim(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
