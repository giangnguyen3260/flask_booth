import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:project_l/common/log/logs_constants.dart';
import 'package:project_l/common/util/directory_utils.dart';

import 'log_mixin.dart';

class LogUtils {
  const LogUtils._();

  /// InitialTab count to _log json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Width size per _log
  /// Print compact json response
  static const bool compact = true;

  static const int maxWidth = 90;

  static File? _logDFile;
  static File? _logEFile;
  static File? _logUFile;

  static Future<void> initialize() async {
    String appDocDir =
        await DirectoryUtils.getFolderByDay(parentFolder: "logs");

    String fileEName = "Error";
    String fileDName = "Debug";
    String fileUName = "UI";

    String logsEPath = path.join(appDocDir, "$fileEName.txt");
    String logsDPath = path.join(appDocDir, "$fileDName.txt");
    String logsUPath = path.join(appDocDir, "$fileUName.txt");

    _logEFile = File(logsEPath);
    _logDFile = File(logsDPath);
    _logUFile = File(logsUPath);

    // Ensure the log file exists
    if (!await _logDFile!.exists()) {
      await _logDFile!.create(recursive: true);
    }
    if (!await _logEFile!.exists()) {
      await _logEFile!.create(recursive: true);
    }
    if (!await _logUFile!.exists()) {
      await _logUFile!.create(recursive: true);
    }
  }

  static void d(
    Object? message, {
    String? name,
    DateTime? time,
  }) {
    _log('💡 $message', name: name ?? '', time: time);
  }

  static void u(
    Object? message, {
    String? name,
    DateTime? time,
  }) {
    _log('💡 $message', name: name ?? '', time: time, isUi: true);
  }

  static void e(
    Object? errorMessage, {
    String? name,
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    _log(
      isError: true,
      '💢 $errorMessage',
      name: name ?? '',
      error: errorObject,
      stackTrace: stackTrace,
      time: time,
    );
  }

  static Future<void> _log(
    String message, {
    bool isError = false,
    bool isUi = false,
    Level level = Level.debug,
    String name = '',
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    LogOutput? output;
    if (isUi) {
      output = (_logUFile != null) ? FileLogOutput(_logUFile!) : null;
    } else if (isError) {
      output = (_logEFile != null) ? FileLogOutput(_logEFile!) : null;
    } else {
      output = (_logDFile != null) ? FileLogOutput(_logDFile!) : null;
    }

    List<LogOutput> listOutput = [
      MyConsoleOutput(),
    ];
    if (output != null) {
      listOutput.add(output);
    }
    var logger = Logger(
        printer: SimplePrinter(printTime: LogsConstants.printTime),
        output: MultiOutput(listOutput),
        filter: ProductionFilter());
    logger.log(
      level,
      "${name.isEmpty ? '' : '[$name]'} ${sequenceNumber != null ? '[$sequenceNumber]' : ''} ${zone != null ? '[$zone]' : ''} $message",
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

// static String _indent([int tabCount = initialTab]) => tabStep * tabCount;

// static void printPrettyMap(
//   Map data, {
//   int tabs = initialTab,
//   bool isListItem = false,
//   bool isLast = false,
// }) {
//   final isRoot = tabs == initialTab;
//   final initialIndent = _indent(tabs);
//   tabs++;
//
//   if (isRoot || isListItem) _log('║$initialIndent{');
//
//   data.keys.toList().asMap().forEach((index, dynamic key) {
//     final isLast = index == data.length - 1;
//     dynamic value = data[key];
//     if (value is String) {
//       value = '"${value.toString().replaceAll(RegExp(r'([\r\n])+'), " ")}"';
//     }
//     if (value is Map) {
//       if (compact && _canFlattenMap(value)) {
//         _log('║${_indent(tabs)} $key: $value${!isLast ? ',' : ''}');
//       } else {
//         _log('║${_indent(tabs)} $key: {');
//         printPrettyMap(value, tabs: tabs);
//       }
//     } else if (value is List) {
//       if (compact && _canFlattenList(value)) {
//         _log('║${_indent(tabs)} $key: ${value.toString()}');
//       } else {
//         _log('║${_indent(tabs)} $key: ');
//         printList(value, tabs: tabs);
//         _log('║${_indent(tabs)} ${isLast ? '' : ','}');
//       }
//     } else {
//       final msg = value.toString().replaceAll('\n', '');
//       final indent = _indent(tabs);
//       final linWidth = maxWidth - indent.length;
//       if (msg.length + indent.length > linWidth) {
//         final lines = (msg.length / linWidth).ceil();
//
//         for (var i = 0; i < (lines > 10 ? 10 : lines); ++i) {
//           _log(
//               '║${_indent(tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
//         }
//       } else {
//         _log('║${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}');
//       }
//     }
//   });
//
//   _log('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
// }

// static void printList(List list, {int tabs = initialTab}) {
//   _log('║${_indent()}[');
//   list.asMap().forEach((i, dynamic e) {
//     final isLast = i == list.length - 1;
//     if (e is Map) {
//       if (compact && _canFlattenMap(e)) {
//         _log('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
//       } else {
//         printPrettyMap(e, tabs: tabs + 1, isListItem: true, isLast: isLast);
//       }
//     } else {
//       _log('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
//     }
//   });
//
//   _log('║${_indent()}]');
// }

// static bool _canFlattenMap(Map map) {
//   return map.values
//           .where((dynamic val) => val is Map || val is List)
//           .isEmpty &&
//       map.toString().length < maxWidth;
// }
//
// static bool _canFlattenList(List list) {
//   return list.length < 10 && list.toString().length < maxWidth;
// }
}
