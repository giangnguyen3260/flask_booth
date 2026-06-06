import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../ffmpeg_helper.dart';

class FFMpegHelper {
  static final FFMpegHelper _singleton = FFMpegHelper._internal();
  factory FFMpegHelper() => _singleton;
  FFMpegHelper._internal();
  static FFMpegHelper get instance => _singleton;

  Future<FFMpegHelperSession> runAsync(
    FFMpegCommand command, {
    Function(Statistics statistics)? statisticsCallback,
    Function(File? outputFile)? onComplete,
  }) async {
    if (Platform.isWindows || Platform.isLinux) {
      return _runAsyncOnWindows(
        command,
        statisticsCallback: statisticsCallback,
        onComplete: onComplete,
      );
    } else {
      return _runAsyncOnNonWindows(
        command,
        statisticsCallback: statisticsCallback,
        onComplete: onComplete,
      );
    }
  }

  Future<FFMpegHelperSession> _runAsyncOnWindows(
    FFMpegCommand command, {
    Function(Statistics statistics)? statisticsCallback,
    Function(File? outputFile)? onComplete,
  }) async {
    Process process = await _startWindowsProcess(
      command,
      statisticsCallback: statisticsCallback,
    );
    process.exitCode.then((value) {
      if (value == ReturnCode.success) {
        onComplete?.call(File(command.outputFilepath));
      } else {
        onComplete?.call(null);
      }
      process.kill();
    });
    return FFMpegHelperSession(
      windowSession: process,
      cancelSession: () async {
        process.kill();
      },
    );
  }

  Future<FFMpegHelperSession> _runAsyncOnNonWindows(
    FFMpegCommand command, {
    Function(Statistics statistics)? statisticsCallback,
    Function(File? outputFile)? onComplete,
  }) async {
    FFmpegSession sess = await FFmpegKit.executeAsync(
      command.toCli().join(' '),
      (FFmpegSession session) async {
        final code = await session.getReturnCode();
        if (code?.isValueSuccess() == true) {
          onComplete?.call(File(command.outputFilepath));
        } else {
          onComplete?.call(null);
        }
      },
      null,
      (Statistics statistics) {
        statisticsCallback?.call(statistics);
      },
    );
    return FFMpegHelperSession(
      nonWindowSession: sess,
      cancelSession: () async {
        await sess.cancel();
      },
    );
  }

  Future<File?> runSync(
    FFMpegCommand command, {
    Function(Statistics statistics)? statisticsCallback,
  }) async {
    if (Platform.isWindows || Platform.isLinux) {
      return _runSyncOnWindows(
        command,
        statisticsCallback: statisticsCallback,
      );
    } else {
      return _runSyncOnNonWindows(
        command,
        statisticsCallback: statisticsCallback,
      );
    }
  }

  Future<Process> _startWindowsProcess(
    FFMpegCommand command, {
    Function(Statistics statistics)? statisticsCallback,
  }) async {
    final String ffmpeg = _resolveFfmpegExecutable();
    Process process = await Process.start(
      ffmpeg,
      command.toCli(),
    );
    process.stdout.transform(utf8.decoder).listen((String event) {
      List<String> data = event.split("\n");
      Map<String, dynamic> temp = {};
      for (String element in data) {
        List<String> kv = element.split("=");
        if (kv.length == 2) {
          temp[kv.first] = kv.last;
        }
      }
      if (temp.isNotEmpty) {
        try {
          statisticsCallback?.call(Statistics(
            process.pid,
            int.tryParse(temp['frame']) ?? 0,
            double.tryParse(temp['fps']) ?? 0.0,
            double.tryParse(temp['stream_0_0_q']) ?? 0.0,
            int.tryParse(temp['total_size']) ?? 0,
            (int.tryParse(temp['out_time_us']) ?? 0).toDouble(),
            // 2189.6kbits/s => 2189.6
            double.tryParse(
                    temp['bitrate']?.replaceAll(RegExp('[a-z/]'), '')) ??
                0.0,
            // 2.15x => 2.15
            double.tryParse(temp['speed']?.replaceAll(RegExp('[a-z/]'), '')) ??
                0.0,
          ));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    });
    process.stderr.transform(utf8.decoder).listen((event) {
      if (kDebugMode) {
        print("stderr: $event");
      }
    });
    return process;
  }

  String _resolveFfmpegExecutable() {
    if (!Platform.isWindows) {
      return 'ffmpeg';
    }

    final candidates = <String>[];

    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData != null && localAppData.isNotEmpty) {
      final packageRoot =
          Directory('$localAppData\\Microsoft\\WinGet\\Packages');
      if (packageRoot.existsSync()) {
        for (final entity in packageRoot.listSync(recursive: true)) {
          if (entity is File &&
              entity.path.toLowerCase().endsWith('\\bin\\ffmpeg.exe')) {
            candidates.add(entity.path);
          }
        }
      }
      candidates.addAll([
        '$localAppData\\Microsoft\\WinGet\\Links\\ffmpeg.exe',
        '$localAppData\\Microsoft\\WindowsApps\\ffmpeg.exe',
      ]);
    }

    for (final candidate in candidates) {
      try {
        if (File(candidate).existsSync()) {
          return candidate;
        }
      } catch (_) {
        // Keep probing candidates; some package folders are protected.
      }
    }
    return 'ffmpeg';
  }

  Future<File?> _runSyncOnWindows(
    FFMpegCommand command, {
    Function(Statistics statistics)? statisticsCallback,
  }) async {
    Process process = await _startWindowsProcess(
      command,
      statisticsCallback: statisticsCallback,
    );
    if (await process.exitCode == ReturnCode.success) {
      process.kill();
      return File(command.outputFilepath);
    } else {
      process.kill();
      return null;
    }
  }

  Future<File?> _runSyncOnNonWindows(
    FFMpegCommand command, {
    Function(Statistics statistics)? statisticsCallback,
  }) async {
    Completer<File?> completer = Completer<File?>();
    await FFmpegKit.executeAsync(
      command.toCli().join(' '),
      (FFmpegSession session) async {
        final code = await session.getReturnCode();
        if (code?.isValueSuccess() == true) {
          if (!completer.isCompleted) {
            completer.complete(File(command.outputFilepath));
          }
        } else {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        }
      },
      null,
      (Statistics statistics) {
        statisticsCallback?.call(statistics);
      },
    );
    return completer.future;
  }

  Future<MediaInformation?> runProbe(String filePath) async {
    if (Platform.isWindows || Platform.isLinux) {
      return _runProbeOnWindows(filePath);
    } else {
      return _runProbeOnNonWindows(filePath);
    }
  }

  Future<MediaInformation?> _runProbeOnNonWindows(String filePath) async {
    Completer<MediaInformation?> completer = Completer<MediaInformation?>();
    try {
      await FFprobeKit.getMediaInformationAsync(filePath,
          (MediaInformationSession session) async {
        final MediaInformation? information = session.getMediaInformation();
        if (information != null) {
          if (!completer.isCompleted) {
            completer.complete(information);
          }
        } else {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        }
      });
    } catch (e) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }
    return completer.future;
  }

  Future<MediaInformation?> _runProbeOnWindows(String filePath) async {
    String ffprobe = 'ffprobe';
    final result = await Process.run(ffprobe, [
      '-v',
      'quiet',
      '-print_format',
      'json',
      '-show_format',
      '-show_streams',
      '-show_chapters',
      filePath,
    ]);
    if (result.stdout == null ||
        result.stdout is! String ||
        (result.stdout as String).isEmpty) {
      return null;
    }
    if (result.exitCode == ReturnCode.success) {
      try {
        final json = jsonDecode(result.stdout);
        return MediaInformation(json);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<FFMpegHelperSession> getThumbnailFileAsync({
    required String videoPath,
    required Duration fromDuration,
    required String outputPath,
    String? ffmpegPath,
    FilterGraph? filterGraph,
    int qualityPercentage = 100,
    Function(Statistics statistics)? statisticsCallback,
    Function(File? outputFile)? onComplete,
  }) async {
    int quality = 1;
    if ((qualityPercentage > 0) && (qualityPercentage < 100)) {
      quality = (((100 - qualityPercentage) * 31) / 100).ceil();
    }
    final FFMpegCommand cliCommand = FFMpegCommand(
      returnProgress: true,
      inputs: [FFMpegInput.asset(videoPath)],
      args: [
        const OverwriteArgument(),
        SeekArgument(fromDuration),
        const CustomArgument(["-frames:v", '1']),
        CustomArgument(["-q:v", '$quality']),
      ],
      outputFilepath: outputPath,
      filterGraph: filterGraph,
    );
    FFMpegHelperSession session = await runAsync(
      cliCommand,
      onComplete: onComplete,
      statisticsCallback: statisticsCallback,
    );
    return session;
  }

  Future<File?> getThumbnailFileSync({
    required String videoPath,
    required Duration fromDuration,
    required String outputPath,
    String? ffmpegPath,
    FilterGraph? filterGraph,
    int qualityPercentage = 100,
    Function(Statistics statistics)? statisticsCallback,
    Function(File? outputFile)? onComplete,
  }) async {
    int quality = 1;
    if ((qualityPercentage > 0) && (qualityPercentage < 100)) {
      quality = (((100 - qualityPercentage) * 31) / 100).ceil();
    }
    final FFMpegCommand cliCommand = FFMpegCommand(
      returnProgress: true,
      inputs: [FFMpegInput.asset(videoPath)],
      args: [
        const OverwriteArgument(),
        SeekArgument(fromDuration),
        const CustomArgument(["-frames:v", '1']),
        CustomArgument(["-q:v", '$quality']),
      ],
      outputFilepath: outputPath,
      filterGraph: filterGraph,
    );
    File? session = await runSync(
      cliCommand,
      statisticsCallback: statisticsCallback,
    );
    return session;
  }
}
