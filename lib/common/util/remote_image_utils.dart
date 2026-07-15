import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/util/directory_utils.dart';

@Injectable()
class RemoteImageUtils with LogMixin {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
  ));
  late String savePath;
  late final Future<void> _initFuture;

  RemoteImageUtils() {
    _initFuture = _init();
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );
  }

  Future<void> _init() async {
    String savePath =
        await DirectoryUtils.documentDirectory(parentFolder: "backgrounds");
    this.savePath = savePath;
  }

  Future<String> downloadAndSaveFile(
    String url,
    String fileName, [
    Function(int, int)? onReceiveProgress,
    int counter = 0,
  ]) async {
    if (counter >= 3) {
      return "";
    }
    await _initFuture;
    final filePath = path.join(savePath, fileName);
    final file = File(filePath);
    if (file.existsSync() && await file.length() > 0) {
      return filePath;
    }
    try {
      if (file.existsSync()) {
        await file.delete();
      }
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: onReceiveProgress,
      );
      if (!file.existsSync() || await file.length() == 0) {
        throw DioException(
          requestOptions: RequestOptions(path: url),
          message: 'Downloaded image is empty',
        );
      }
      return filePath;
    } on DioException catch (e) {
      logE(e);
      if (file.existsSync()) {
        try {
          await file.delete();
        } catch (_) {}
      }
      return downloadAndSaveFile(url, fileName, onReceiveProgress, counter + 1);
    }
  }
}
