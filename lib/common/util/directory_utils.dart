import 'dart:io';

import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DirectoryUtils {
  static Future<Directory> temporaryDirectory() => getTemporaryDirectory();

  static Future<String> documentDirectory(
      {required String parentFolder}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    Directory appDocDir = await getApplicationDocumentsDirectory();

    final customPath = path.join(appDocDir.path, appName, parentFolder);
    Directory doc = Directory(customPath);
    if (!doc.existsSync()) {
      doc.createSync(recursive: true);
    }
    return customPath;
  }

  static Future<String> getFolderByDay({required String parentFolder}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String customPath = path.join(
      appDocDir.path,
      appName,
      parentFolder,
      today,
    );
    Directory doc = Directory(customPath);
    if (!doc.existsSync()) {
      doc.createSync(recursive: true);
    }
    return customPath;
  }

  static Future<String> getFolderByTime({required String parentFolder}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final currentTime = DateFormat('hh-mm-ss').format(DateTime.now());
    String savePath = path.join(
      appDocDir.path,
      appName,
      parentFolder,
      today,
      currentTime,
    );
    Directory doc = Directory(savePath);
    if (!doc.existsSync()) {
      doc.createSync(recursive: true);
    }
    return savePath;
  }

  static Future<void> createTodayAllFolder() async {
    await createTodayFolderToDocument(parentFolder: "images");
    await createTodayFolderToDocument(parentFolder: "videos");
    await createTodayFolderToDocument(parentFolder: "zipFiles");
    await createTodayFolderToDocument(parentFolder: "qrCode");
    await createTodayFolderToDocument(parentFolder: "Temp_Images");
    await createTodayFolderToDocument(parentFolder: "Temp_Videos");
  }

  static Future<void> createTodayFolderToDocument(
      {required String parentFolder}) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String todayPath = await getFolderByDay(parentFolder: parentFolder);
    String parentDir = todayPath.replaceAll("\\$today", '');
    final todayFolder = Directory(parentDir);

    // Nếu chưa tồn tại thì tạo folder
    if (!(await todayFolder.exists())) {
      // await todayFolder.create(recursive: true);
    }

    // Xóa folder cũ
    await _deleteOldFolders(todayFolder, today);
  }

  static Future<void> _deleteOldFolders(
      Directory parentDir, String today) async {
    final entities = parentDir.listSync();

    for (var entity in entities) {
      if (entity is Directory) {
        final folderName = entity.path.split('\\').last; // Lấy tên folder
        if (folderName != today) {
          // Nếu folder cũ hơn hôm nay
          await entity.delete(recursive: true);
        }
      }
    }
  }

  static Future<bool> createNewFolder({
    required String parentPath,
    required String folder,
  }) async {
    try {
      final directory = Directory(path.join(parentPath, folder));
      if (await directory.exists()) {
        print('Thư mục đã tồn tại: ${directory.path}');
        return true;
      } else {
        await directory.create(recursive: true);
        print('Đã tạo thư mục: ${directory.path}');
        return true;
      }
    } catch (e) {
      print('Lỗi khi tạo thư mục: $e');
      return false;
    }
  }
}
