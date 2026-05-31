import 'package:dio/dio.dart';

abstract class AppNetworkProvider {
  final Dio appDio = Dio();

  AppNetworkProvider() {
    init();
    addInterceptor();
  }

  String getBaseUrl();

  void init();

  void addInterceptor();

  void close({bool isForce = false}) {
    appDio.close(force: isForce);
  }
}
