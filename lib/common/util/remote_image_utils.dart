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
    connectTimeout: const Duration(seconds: 3),
    sendTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
  ));
  late String savePath;

  RemoteImageUtils() {
    _init();
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
    if (counter == 3) {
      return "";
    }
    try {
      String filePath = path.join(savePath, fileName);
      // Download the file
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: onReceiveProgress,
      );

      return filePath;
    } on DioException catch (e) {
      logE(e);
      return downloadAndSaveFile(url, fileName, onReceiveProgress, counter + 1);
    }
  }
}
