import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:mysql_utils/mysql_utils.dart';
import 'package:mysql_client_plus/mysql_client_plus.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/select_filter/provider/select_filter_listen_state.dart';
import 'package:project_l/remote/models/len_info.dart';
import 'package:project_l/remote/models/snap_setting.dart';
import 'package:collection/collection.dart';

@Injectable()
class SelectFilterProvider extends BaseProvider<SelectFilterListenState> {
  List<LenInfo> lens = [];
  bool isLoading = true;


  void init() async {
    String path = r'C:\Users\p5k\AppData\Local\Snap\Snap Camera\settings.json';

    File file = File(path);
    String content = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(content);
    final ss = SnapSetting.fromJson(jsonData);
    final List<LensesShortcuts> shortcuts =
        ss.settings?.shortcuts?.lensesShortcuts ?? [];
    final lensId = shortcuts.map((e) => e.lensId).toList();
    var db = MysqlUtils(
        settings: {
          'host': '127.0.0.1',
          'port': 3306,
          'user': 'root',
          'password': '123456',
          'db': 'snapcamera',
          'maxConnections': 10,
          'secure': true,
          'prefix': '',
          'pool': true,
          'collation': 'utf8mb4_general_ci',
          'sqlEscape': true,
        },
        errorLog: (error) {
          logE(error);
        },
        sqlLog: (sql) {
          logD(sql);
        },
        connectInit: (db1) async {
          logD('SQL whenComplete');
        });
    final placeholders = lensId.map((id) => '$id').join(', ');

    var result = await db
        .query('select * from lenses where unlockable_id in ($placeholders)');
    db.close();
    List<LenInfo> items = result.rowsAssoc.map((row) {
      return LenInfo.fromJson((row as ResultSetRow).assoc());
    }).toList();

    lens.clear();

    for (var e in items) {
      final found = shortcuts.firstWhereOrNull((e2) =>
          e2.lensId == e.unlockableId && (e2.shortcut ?? "").isNotEmpty);
      if (found != null) {
        final f = e.copyWith(shotCut: found.shortcut);
        lens.add(f);
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
