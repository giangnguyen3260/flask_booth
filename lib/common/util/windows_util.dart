import 'dart:io' as io;

import 'package:restartfromos/restartatos.dart';

class WindowsUtil {
  static void restartApp({required String appName}) {
    RestartFromOS.restartApp(appName: appName);
  }

  static Future<int> getAppMemoryUsage() async {
    int pid = io.pid;

    // Gọi lệnh wmic để lấy thông tin bộ nhớ
    final result = await io.Process.run('wmic',
        ['process', 'where', 'ProcessId=$pid', 'get', 'WorkingSetSize']);

    if (result.exitCode == 0) {
      String output = result.stdout.toString().trim();
      // Lọc bỏ tiêu đề và chỉ lấy giá trị
      List<String> lines = output.split('\n');
      if (lines.length > 1) {
        String memoryBytes = lines[1].trim();
        int memoryMB =
            int.parse(memoryBytes) ~/ 1024 ~/ 1024; // Chuyển từ bytes sang KB
        print('Memory Usage: $memoryMB MB');
        return memoryMB;
      } else {
        print('Không tìm thấy thông tin bộ nhớ.');
        return 0;
      }
    } else {
      print('Lỗi khi chạy wmic: ${result.stderr}');
      return 0;
    }
  }
}
