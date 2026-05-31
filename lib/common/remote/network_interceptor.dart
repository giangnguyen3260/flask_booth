import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/log/log_config.dart';
import 'package:project_l/common/log/log_interceptor_mixin.dart';


@Injectable()
class NetworkInterceptor extends QueuedInterceptorsWrapper
    with LogInterceptorMixin {


  NetworkInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    // options.headers.addAll(_buildHeader());
    if (LogConfig.enableLogRequestInfo) {
      logD("************ On request ************");
      logD(options.uri.toString());
      logD(options.data.toString());
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (LogConfig.enableLogErrorResponse &&
        err.type != DioExceptionType.cancel) {
      logE("************ On error ************");
      logE(err.type.name);
      if (err.response != null) {
        logE(err.response!.data);
      }
      if (err.message != null) {
        logE(err.message);
      }
    }
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (LogConfig.enableLogSuccessResponse) {
      logD("************ On response ************");
      // logResponse(response.data);
    }
  }

  // ///add some header attribute here
  // Map<String, dynamic> _buildHeader() {
  //   return {
  //     //todo get from security storage
  //     'Authorization': _storageProvider.readString(HiveConstants.token),
  //   };
  // }
}
