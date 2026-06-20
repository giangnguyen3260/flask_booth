import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:project_l/common/enums/filter_enum.dart';
import 'package:project_l/common/models/effect.dart';
import 'package:project_l/common/models/matrix_param.dart';
import 'package:project_l/common/util/date_time_utils.dart';
import 'package:project_l/common/util/directory_utils.dart';
import 'package:project_l/gen/assets.gen.dart';

@Singleton()
class FfmpegUtils {
  static const Duration _imageMergeTimeout = Duration(seconds: 90);
  static const Duration _imageSlotTimeout = Duration(seconds: 30);
  static const Duration _videoMergeTimeout = Duration(minutes: 8);
  static const Duration _videoSlotTimeout = Duration(seconds: 90);
  static const int _imageMergeThreads = 1;
  static const int _videoMergeThreads = 1;
  static const int _videoOutputFps = 10;
  static const int _videoCrf = 28;
  static const int _videoSlotCrf = 30;

  late final String baseImagePath;
  late final String baseVideoPath;

  String _savedImagePath = "";
  String _savedVideoPath = "";

  FfmpegUtils() {
    DirectoryUtils.documentDirectory(parentFolder: "images").then((imgPath) {
      baseImagePath = imgPath;
    });
    DirectoryUtils.documentDirectory(parentFolder: "videos").then((videoPath) {
      baseVideoPath = videoPath;
    });
  }

  Future<void> createSession({required String sessionId}) async {
    if (await DirectoryUtils.createNewFolder(
        parentPath: baseImagePath, folder: sessionId)) {
      _savedImagePath = path.join(baseImagePath, sessionId);
    }
    if (await DirectoryUtils.createNewFolder(
        parentPath: baseVideoPath, folder: sessionId)) {
      _savedVideoPath = path.join(baseVideoPath, sessionId);
    }
  }

  Future<String> preprocessImage(
      {Effect? effect,
      ColorFilterGenerator? filter,
      required String imagePath,
      required bool isFlip}) async {
    var imagePathSplit = imagePath.split("\\");
    if (imagePathSplit.isEmpty) return "";
    var imageOutput = path.join(_savedImagePath,
        "Processed_${imagePathSplit.last.replaceAll(".JPG", ".png")}");
    final brightness =
        effect?.brightness ?? FilterEnum.brightness.getDefaultValue();
    final contrast = effect?.contrast ?? FilterEnum.contrast.getDefaultValue();
    final saturation =
        effect?.saturation ?? FilterEnum.saturation.getDefaultValue();
    final vibrance = effect?.vibrance ?? FilterEnum.vibrance.getDefaultValue();
    final temperature =
        effect?.temperature ?? FilterEnum.temperature.getDefaultValue();
    final sepia = effect?.sepia ?? FilterEnum.sepia.getDefaultValue();
    final grain = effect?.grain ?? FilterEnum.grain.getDefaultValue();
    if (!isFlip &&
        brightness == FilterEnum.brightness.getDefaultValue() &&
        contrast == FilterEnum.contrast.getDefaultValue() &&
        saturation == FilterEnum.saturation.getDefaultValue() &&
        vibrance == FilterEnum.vibrance.getDefaultValue() &&
        temperature == FilterEnum.temperature.getDefaultValue() &&
        sepia == FilterEnum.sepia.getDefaultValue() &&
        grain == FilterEnum.grain.getDefaultValue()) {
      await File(imagePath).copy(imageOutput);
      return imageOutput;
    }
    ProcessResult process =
        await Process.run(_resolveAssetFile(Assets.files.main), [
      "--input",
      imagePath,
      "--output",
      imageOutput,
      "--brightness",
      "$brightness",
      "--contrast",
      "$contrast",
      "--saturation",
      "$saturation",
      "--vibrance",
      "$vibrance",
      "--temperature",
      "$temperature",
      "--sepia",
      "$sepia",
      "--grain",
      "$grain",
      "--flipX",
      (isFlip ? "True" : "False")
    ]).timeout(const Duration(seconds: 20));

    if (kDebugMode) {
      print(process.stdout);
    }
    return imageOutput;
  }

  String _resolveAssetFile(String assetPath) {
    if (File(assetPath).existsSync()) {
      return assetPath;
    }
    final executableDir = path.dirname(Platform.resolvedExecutable);
    final bundledPath = path.joinAll([
      executableDir,
      'data',
      'flutter_assets',
      ...assetPath.split('/'),
    ]);
    if (File(bundledPath).existsSync()) {
      return bundledPath;
    }
    return assetPath;
  }

  String convertMatrixToGeq(List<double> matrix) {
    // Ensure the matrix has the correct number of elements
    if (matrix.length != 20) {
      throw ArgumentError('Matrix must have exactly 20 elements.');
    }

    // Extract rows from the matrix
    List<double> rCoeffs =
        matrix.sublist(0, 5); // First row: R coefficients + bias
    List<double> gCoeffs =
        matrix.sublist(5, 10); // Second row: G coefficients + bias
    List<double> bCoeffs =
        matrix.sublist(10, 15); // Third row: B coefficients + bias

    // Helper function to convert a single row into a geq equation
    String rowToGeq(String channel, List<double> coeffs) {
      return "clip(${coeffs[0]}*$channel(X,Y)"
          "${coeffs[1] >= 0 ? '+' : ''}${coeffs[1]}*g(X,Y)"
          "${coeffs[2] >= 0 ? '+' : ''}${coeffs[2]}*b(X,Y)"
          "${coeffs[4] >= 0 ? '+' : ''}${coeffs[4]},0,255)";
    }

    // Convert each row into the geq format
    String rGeq = "r='${rowToGeq('r', rCoeffs)}'";
    String gGeq = "g='${rowToGeq('g', gCoeffs)}'";
    String bGeq = "b='${rowToGeq('b', bCoeffs)}'";

    // Combine into the final geq filter format for FFmpeg
    return "$rGeq:$gGeq:$bGeq:a='255'";
  }

  Future<String> mergeImage(
      {required String backgroundPath,
      required String frameOverlayPath,
      required List<String> images,
      required List<List<double>> transparents,
      required List<MatrixParam> params,
      required bool flip}) async {
    final preparedSlots = await _prepareImageSlots(
      images: images,
      transparents: transparents,
      params: params,
      flip: false,  // flip already applied by preprocessImage before mergeImage is called
    );
    try {
      return await _mergePreparedImageSlots(
        backgroundPath: backgroundPath,
        frameOverlayPath: frameOverlayPath,
        slots: preparedSlots,
        transparents: transparents,
      );
    } finally {
      for (final slotPath in preparedSlots) {
        try {
          final slotFile = File(slotPath);
          if (slotFile.existsSync()) {
            await slotFile.delete();
          }
        } catch (_) {
          // Temporary slot cleanup is best-effort.
        }
      }
    }
  }

  Future<List<String>> _prepareImageSlots({
    required List<String> images,
    required List<List<double>> transparents,
    required List<MatrixParam> params,
    required bool flip,
  }) async {
    _validateImageMergeInputs(
      images: images,
      transparents: transparents,
      params: params,
    );

    final slotPaths = <String>[];
    final slotDirectory = Directory(path.join(
      _savedImagePath,
      'slots_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss_SSS")}',
    ));
    await slotDirectory.create(recursive: true);

    try {
      for (var i = 0; i < images.length; i++) {
        final slotOutput = path.join(slotDirectory.path, 'Slot_$i.png');
        final slotWidth = _positiveInt(transparents[i][2]);
        final slotHeight = _positiveInt(transparents[i][3]);
        final sourceSize = await _readImageSize(images[i]);
        final scale = _effectiveSlotScale(
          sourceWidth: sourceSize.$1,
          sourceHeight: sourceSize.$2,
          slotWidth: slotWidth,
          slotHeight: slotHeight,
          requestedScale: params[i].scale,
        );
        final scaledWidth = math.max(slotWidth, (sourceSize.$1 * scale).ceil());
        final scaledHeight =
            math.max(slotHeight, (sourceSize.$2 * scale).ceil());
        final maxCropX = math.max(0, scaledWidth - slotWidth).toDouble();
        final maxCropY = math.max(0, scaledHeight - slotHeight).toDouble();
        final cropX = params[i].panX.abs().clamp(0.0, maxCropX);
        final cropY = params[i].panY.abs().clamp(0.0, maxCropY);
        final filters = <String>[
          if (flip) 'hflip',
          'scale=$scaledWidth:$scaledHeight',
          'crop=$slotWidth:$slotHeight:$cropX:$cropY',
        ].join(',');

        final stopwatch = Stopwatch()..start();
        if (kDebugMode) {
          print(
            'FFmpeg image slot start: ${i + 1}/${images.length} '
            'source=${sourceSize.$1}x${sourceSize.$2} '
            'scaled=${scaledWidth}x$scaledHeight '
            'slot=${slotWidth}x$slotHeight input=${images[i]}',
          );
        }
        final outputFile = await FFMpegHelper.instance.runSync(
          FFMpegCommand(outputFilepath: slotOutput, inputs: [
            FFMpegInput([
              '-i',
              images[i],
              '-vf',
              filters,
              '-frames:v',
              '1',
              '-c:v',
              'png',
              '-compression_level',
              '1',
            ]),
          ]),
          timeout: _imageSlotTimeout,
        );
        if (outputFile == null || !outputFile.existsSync()) {
          throw StateError(
              'FFmpeg image slot failed: index=$i output=$slotOutput');
        }
        if (kDebugMode) {
          print(
            'FFmpeg image slot done: ${i + 1}/${images.length} '
            'elapsed=${stopwatch.elapsedMilliseconds}ms output=$slotOutput',
          );
        }
        slotPaths.add(slotOutput);
      }
      return slotPaths;
    } catch (_) {
      for (final slotPath in slotPaths) {
        try {
          final slotFile = File(slotPath);
          if (slotFile.existsSync()) {
            await slotFile.delete();
          }
        } catch (_) {
          // Temporary slot cleanup is best-effort.
        }
      }
      rethrow;
    }
  }

  Future<String> _mergePreparedImageSlots({
    required String backgroundPath,
    required String frameOverlayPath,
    required List<String> slots,
    required List<List<double>> transparents,
  }) async {
    var imageOutput = path.join(_savedImagePath,
        "Output_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm")}.png");

    final outputFile = await FFMpegHelper.instance.runSync(
      FFMpegCommand(outputFilepath: imageOutput, inputs: [
        FFMpegInput([
          ...generatePreparedSlotOverlayCommand(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            slots: slots,
            transparents: transparents,
            threadCount: _imageMergeThreads,
          ),
          '-q:v',
          '2',
          "-c:v",
          "png"
        ]),
      ]),
      timeout: _imageMergeTimeout,
    );
    if (outputFile == null || !outputFile.existsSync()) {
      throw StateError('FFmpeg image merge failed: $imageOutput');
    }
    return imageOutput;
  }

  void _validateImageMergeInputs({
    required List<String> images,
    required List<List<double>> transparents,
    required List<MatrixParam> params,
  }) {
    if (images.length != transparents.length) {
      throw StateError(
        'Image merge input mismatch: images=${images.length} '
        'transparents=${transparents.length}',
      );
    }
    if (images.length != params.length) {
      throw StateError(
        'Image merge input mismatch: images=${images.length} '
        'params=${params.length}',
      );
    }
    for (var i = 0; i < transparents.length; i++) {
      if (transparents[i].length < 4) {
        throw StateError('Invalid transparent area at index $i');
      }
    }
  }

  int _positiveInt(double value) {
    final rounded = value.round();
    return rounded < 1 ? 1 : rounded;
  }

  Future<(int, int)> _readImageSize(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw StateError('Could not decode image size: $imagePath');
    }
    return (decoded.width, decoded.height);
  }

  double _effectiveSlotScale({
    required int sourceWidth,
    required int sourceHeight,
    required int slotWidth,
    required int slotHeight,
    required double requestedScale,
  }) {
    final normalizedScale = requestedScale <= 0 ? 1.0 : requestedScale;
    return math.max(
      normalizedScale,
      math.max(slotWidth / sourceWidth, slotHeight / sourceHeight),
    );
  }

  Future<String> mergeHorizontalImage({required String imagePath}) async {
    var imageOutput = path.join(_savedImagePath,
        "Print_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss")}.png");

    await FFMpegHelper.instance.runSync(
      FFMpegCommand(outputFilepath: imageOutput, inputs: [
        FFMpegInput(
          [
            '-i',
            imagePath,
            '-i',
            imagePath,
            '-filter_complex',
            'hstack',
            "-q:v",
            "2"
          ],
        )
      ]),
    );
    return imageOutput;
  }

  Future<String> overlayQrOnImage({
    required String imagePath,
    required List<int> qrBytes,
    int qrSize = 220,
    int margin = 30,
  }) async {
    final qrTempPath = path.join(
      _savedImagePath,
      'qr_temp_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss")}.png',
    );
    final output = path.join(
      _savedImagePath,
      'QR_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss")}.png',
    );
    try {
      await File(qrTempPath).writeAsBytes(qrBytes);
      final outputFile = await FFMpegHelper.instance.runSync(
        FFMpegCommand(outputFilepath: output, inputs: [
          FFMpegInput([
            '-i', imagePath,
            '-i', qrTempPath,
            '-filter_complex',
            '[1:v]scale=$qrSize:$qrSize[qr];[0:v][qr]overlay=W-w-$margin:H-h-$margin',
            '-frames:v', '1',
            '-c:v', 'png',
            '-y',
          ]),
        ]),
        timeout: const Duration(seconds: 30),
      );
      if (outputFile != null && outputFile.existsSync()) {
        return output;
      }
    } catch (_) {
    } finally {
      try { File(qrTempPath).deleteSync(); } catch (_) {}
    }
    return imagePath;
  }

  Future<String> mergeVideo(
      {required String backgroundPath,
      required String frameOverlayPath,
      required List<String> videos,
      required List<List<double>> transparents,
      required List<MatrixParam> params,
      required bool flip}) async {
    final preparedSlots = await _prepareVideoSlots(
      videos: videos,
      transparents: transparents,
      params: params,
      flip: flip,
    );
    try {
      return await _mergePreparedVideoSlots(
        backgroundPath: backgroundPath,
        frameOverlayPath: frameOverlayPath,
        slots: preparedSlots,
        transparents: transparents,
      );
    } finally {
      for (final slotPath in preparedSlots) {
        try {
          final slotFile = File(slotPath);
          if (slotFile.existsSync()) {
            await slotFile.delete();
          }
        } catch (_) {
          // Temporary slot cleanup is best-effort.
        }
      }
    }
  }

  Future<List<String>> _prepareVideoSlots({
    required List<String> videos,
    required List<List<double>> transparents,
    required List<MatrixParam> params,
    required bool flip,
  }) async {
    _validateImageMergeInputs(
      images: videos,
      transparents: transparents,
      params: params,
    );

    final slotPaths = <String>[];
    final slotDirectory = Directory(path.join(
      _savedVideoPath,
      'video_slots_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss_SSS")}',
    ));
    await slotDirectory.create(recursive: true);

    try {
      for (var i = 0; i < videos.length; i++) {
        final slotOutput = path.join(slotDirectory.path, 'VideoSlot_$i.mp4');
        final slotWidth = _positiveInt(transparents[i][2]);
        final slotHeight = _positiveInt(transparents[i][3]);
        final cropX = params[i].panX.abs();
        final cropY = params[i].panY.abs();
        final requestedScale = params[i].scale <= 0 ? 1.0 : params[i].scale;
        final filters = <String>[
          'fps=$_videoOutputFps',
          if (flip) 'hflip',
          'scale=w=max(iw*$requestedScale\\,$slotWidth):h=max(ih*$requestedScale\\,$slotHeight)',
          'crop=$slotWidth:$slotHeight:min($cropX\\,iw-$slotWidth):min($cropY\\,ih-$slotHeight)',
          'pad=width=ceil(iw/2)*2:height=ceil(ih/2)*2',
        ].join(',');

        final stopwatch = Stopwatch()..start();
        if (kDebugMode) {
          print(
            'FFmpeg video slot start: ${i + 1}/${videos.length} '
            'slot=${slotWidth}x$slotHeight input=${videos[i]}',
          );
        }
        final outputFile = await FFMpegHelper.instance.runSync(
          FFMpegCommand(outputFilepath: slotOutput, inputs: [
            FFMpegInput([
              '-i',
              videos[i],
              '-vf',
              filters,
              '-r',
              '$_videoOutputFps',
              '-c:v',
              'libx264',
              '-preset',
              'ultrafast',
              '-crf',
              '$_videoSlotCrf',
              '-pix_fmt',
              'yuv420p',
              '-an',
              '-movflags',
              '+faststart',
            ]),
          ]),
          timeout: _videoSlotTimeout,
        );
        if (outputFile == null || !outputFile.existsSync()) {
          throw StateError(
              'FFmpeg video slot failed: index=$i output=$slotOutput');
        }
        if (kDebugMode) {
          print(
            'FFmpeg video slot done: ${i + 1}/${videos.length} '
            'elapsed=${stopwatch.elapsedMilliseconds}ms output=$slotOutput',
          );
        }
        slotPaths.add(slotOutput);
      }
      return slotPaths;
    } catch (_) {
      for (final slotPath in slotPaths) {
        try {
          final slotFile = File(slotPath);
          if (slotFile.existsSync()) {
            await slotFile.delete();
          }
        } catch (_) {
          // Temporary slot cleanup is best-effort.
        }
      }
      rethrow;
    }
  }

  Future<String> _mergePreparedVideoSlots({
    required String backgroundPath,
    required String frameOverlayPath,
    required List<String> slots,
    required List<List<double>> transparents,
  }) async {
    var videoOutput = path.join(_savedVideoPath,
        "Output_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm")}.mp4");

    final outputFile = await FFMpegHelper.instance.runSync(
      FFMpegCommand(outputFilepath: videoOutput, inputs: [
        FFMpegInput([
          ...generatePreparedVideoSlotOverlayCommand(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            slots: slots,
            transparents: transparents,
            threadCount: _videoMergeThreads,
          ),
          '-r',
          '$_videoOutputFps',
          '-c:v',
          'libx264',
          '-preset',
          'ultrafast',
          '-crf',
          '$_videoCrf',
          '-pix_fmt',
          'yuv420p',
          '-an',
          '-movflags',
          '+faststart',
          '-shortest',
        ]),
      ]),
      timeout: _videoMergeTimeout,
    );
    if (outputFile == null || !outputFile.existsSync()) {
      throw StateError('FFmpeg video merge failed: $videoOutput');
    }
    return videoOutput;
  }

  Future<String> createLightweightSlideshowVideo({
    required String imagePath,
    Duration duration = const Duration(seconds: 6),
  }) async {
    final videoOutput = path.join(_savedVideoPath,
        "Slideshow_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm")}.mp4");

    final outputFile = await FFMpegHelper.instance.runSync(
      FFMpegCommand(outputFilepath: videoOutput, inputs: [
        FFMpegInput([
          '-loop',
          '1',
          '-i',
          imagePath,
          '-vf',
          "fps=8,scale=w='min(720,iw)':h=-2,format=yuv420p",
          '-t',
          '${duration.inSeconds}',
          '-r',
          '8',
          '-c:v',
          'libx264',
          '-preset',
          'ultrafast',
          '-crf',
          '34',
          '-pix_fmt',
          'yuv420p',
          '-an',
          '-movflags',
          '+faststart',
          '-threads',
          '$_videoMergeThreads',
          '-y',
        ]),
      ]),
      timeout: const Duration(seconds: 45),
    );
    if (outputFile == null || !outputFile.existsSync()) {
      throw StateError('FFmpeg slideshow video failed: $videoOutput');
    }
    return videoOutput;
  }

  Future<String> preprocessVideo({
    required String videoPath,
    required bool isFlip,
  }) async {
    var videoPathSplit = videoPath.split("\\");
    if (videoPathSplit.isEmpty) return "";
    var videoOutput =
        path.join(_savedVideoPath, "Processed_${videoPathSplit.last}");

    await FFMpegHelper.instance
        .runSync(FFMpegCommand(outputFilepath: videoOutput, inputs: [
      FFMpegInput(
          ['-i', videoPath, '-vf', (isFlip ? "hflip" : ""), '-y', "-q:v", "2"]),
    ]));
    return videoOutput;
  }

  List<String> generateOverlayCommand({
    required String backgroundPath,
    required String frameOverlayPath,
    required List<String> images,
    required List<List<double>> transparents,
    required List<MatrixParam> params,
    required bool flip, // Thêm biến bool flip vào đây
    int threadCount = 2,
    int? fps,
  }) {
    if (images.length != transparents.length) {
      throw Exception('Số lượng images và transparents phải bằng nhau');
    }

    List<String> command = ['-i', backgroundPath];

    for (int i = 0; i < images.length; i++) {
      command.add('-i');
      command.add(images[i]);
    }

    command.add('-i');
    command.add(frameOverlayPath);

    String filterComplex = '';
    filterComplex +=
        '[0:v] format=rgba,pad=width=ceil(iw/2)*2:height=ceil(ih/2)*2,split=2 [bg_base][bg_top0];';
    String lastOutput = '[bg_base]';
    String backgroundTopOutput = '[bg_top0]';

    for (int i = 0; i < images.length; i++) {
      String currentInput = '[${i + 1}:v]';
      String scaled = '[s$i]';
      String flipped = '[f$i]';
      String cropped = '[c$i]';
      String nextOutput = '[v${i + 1}]';

      double scaleX = params[i].scale; // tỉ lệ scale theo width
      double scaleY = params[i].scale; // tỉ lệ scale theo height
      double cropX = params[i].panX.abs(); // crop bắt đầu từ x
      double cropY = params[i].panY.abs(); // crop bắt đầu từ y
      double cropW = transparents[i][2]; // crop width
      double cropH = transparents[i][3]; // crop height

      // Nếu flip = true thì thêm thao tác lật ngang (hflip)
      final scaleFilter =
          'scale=w=max(iw*$scaleX\\,$cropW):h=max(ih*$scaleY\\,$cropH)';
      final cropFilter =
          'crop=$cropW:$cropH:min($cropX\\,iw-$cropW):min($cropY\\,ih-$cropH)';
      final fpsPrefix = fps == null ? '' : 'fps=$fps,';
      if (flip) {
        filterComplex += '$currentInput ${fpsPrefix}hflip$flipped;';
        filterComplex += '$flipped $scaleFilter$scaled;';
      } else {
        filterComplex += '$currentInput $fpsPrefix$scaleFilter$scaled;';
      }
      filterComplex += '$scaled $cropFilter$cropped;';
      filterComplex +=
          '$lastOutput$cropped overlay=${transparents[i][0]}:${transparents[i][1]}$nextOutput;';

      lastOutput = nextOutput;
    }

    String finalInputIndex = '[${images.length + 1}:v]';
    filterComplex +=
        '$finalInputIndex pad=width=ceil(iw/2)*2:height=ceil(ih/2)*2 [frame_padded];';
    filterComplex += '$lastOutput[frame_padded] overlay=0:0 [with_frame];';
    filterComplex += '[with_frame]$backgroundTopOutput overlay=0:0';

    command.add("-filter_threads");
    command.add("$threadCount");
    command.add("-filter_complex_threads");
    command.add("$threadCount");
    command.add('-filter_complex');
    command.add(filterComplex.trim());
    command.add("-threads");
    command.add("$threadCount");
    command.add('-y');

    return command;
  }

  List<String> generatePreparedSlotOverlayCommand({
    required String backgroundPath,
    required String frameOverlayPath,
    required List<String> slots,
    required List<List<double>> transparents,
    int threadCount = 2,
  }) {
    if (slots.length != transparents.length) {
      throw StateError(
        'Slot merge input mismatch: slots=${slots.length} '
        'transparents=${transparents.length}',
      );
    }

    final command = <String>['-i', backgroundPath];
    for (final slot in slots) {
      command
        ..add('-i')
        ..add(slot);
    }
    command
      ..add('-i')
      ..add(frameOverlayPath);

    var filterComplex =
        '[0:v] format=rgba,pad=width=ceil(iw/2)*2:height=ceil(ih/2)*2,split=2 [bg_base][bg_top0];';
    var lastOutput = '[bg_base]';
    const backgroundTopOutput = '[bg_top0]';

    for (var i = 0; i < slots.length; i++) {
      final currentInput = '[${i + 1}:v]';
      final formatted = '[slot$i]';
      final nextOutput = '[v${i + 1}]';
      filterComplex += '$currentInput format=rgba$formatted;';
      filterComplex +=
          '$lastOutput$formatted overlay=${transparents[i][0]}:${transparents[i][1]}$nextOutput;';
      lastOutput = nextOutput;
    }

    final finalInputIndex = '[${slots.length + 1}:v]';
    filterComplex +=
        '$finalInputIndex pad=width=ceil(iw/2)*2:height=ceil(ih/2)*2 [frame_padded];';
    filterComplex += '$lastOutput[frame_padded] overlay=0:0 [with_frame];';
    filterComplex += '[with_frame]$backgroundTopOutput overlay=0:0';

    command
      ..add("-filter_threads")
      ..add("$threadCount")
      ..add("-filter_complex_threads")
      ..add("$threadCount")
      ..add('-filter_complex')
      ..add(filterComplex.trim())
      ..add("-threads")
      ..add("$threadCount")
      ..add('-y');

    return command;
  }

  List<String> generatePreparedVideoSlotOverlayCommand({
    required String backgroundPath,
    required String frameOverlayPath,
    required List<String> slots,
    required List<List<double>> transparents,
    int threadCount = 2,
  }) {
    if (slots.length != transparents.length) {
      throw StateError(
        'Video slot merge input mismatch: slots=${slots.length} '
        'transparents=${transparents.length}',
      );
    }

    final command = <String>['-loop', '1', '-i', backgroundPath];
    for (final slot in slots) {
      command
        ..add('-i')
        ..add(slot);
    }
    command
      ..add('-loop')
      ..add('1')
      ..add('-i')
      ..add(frameOverlayPath);

    var filterComplex =
        '[0:v] fps=$_videoOutputFps,format=rgba,pad=width=ceil(iw/2)*2:height=ceil(ih/2)*2,split=2 [bg_base][bg_top0];';
    var lastOutput = '[bg_base]';
    const backgroundTopOutput = '[bg_top0]';

    for (var i = 0; i < slots.length; i++) {
      final currentInput = '[${i + 1}:v]';
      final formatted = '[slot$i]';
      final nextOutput = '[v${i + 1}]';
      filterComplex += '$currentInput fps=$_videoOutputFps,format=rgba$formatted;';
      filterComplex +=
          '$lastOutput$formatted overlay=${transparents[i][0]}:${transparents[i][1]}:shortest=0$nextOutput;';
      lastOutput = nextOutput;
    }

    final finalInputIndex = '[${slots.length + 1}:v]';
    filterComplex +=
        '$finalInputIndex fps=$_videoOutputFps,pad=width=ceil(iw/2)*2:height=ceil(ih/2)*2 [frame_padded];';
    filterComplex += '$lastOutput[frame_padded] overlay=0:0:shortest=0 [with_frame];';
    filterComplex +=
        '[with_frame]$backgroundTopOutput overlay=0:0:shortest=0';

    command
      ..add("-filter_threads")
      ..add("$threadCount")
      ..add("-filter_complex_threads")
      ..add("$threadCount")
      ..add('-filter_complex')
      ..add(filterComplex.trim())
      ..add("-threads")
      ..add("$threadCount")
      ..add('-y');

    return command;
  }

  Future<void> preprocessShootingImage(
      {required String imagePath,
      required double width,
      required double height,
      dynamic Function(File?)? onComplete}) async {
    var imagePathSplit = imagePath.split("\\");
    if (imagePathSplit.isEmpty) return;
    var imageOutput = path.join(_savedImagePath,
        "Preprocess_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss")}.png");
    int scaledWidth = roundToNearestEven(width);
    int scaledHeight = roundToNearestEven(height);
    await FFMpegHelper.instance.runAsync(
        FFMpegCommand(outputFilepath: imageOutput, inputs: [
          FFMpegInput(
            [
              '-i',
              imagePath,
              '-vf',
              '[0:v]scale=$scaledWidth:$scaledHeight:force_original_aspect_ratio=increase[scaled];[scaled]crop=$scaledWidth:$scaledHeight[cropped];[cropped]hflip',
              "-y",
              '-q:v',
              '2',
              "-c:v",
              "png"
            ],
          ),
        ]),
        onComplete: onComplete);
  }

  Future<void> preprocessShootingVideo(
      {required String videoPath,
      required double width,
      required double height,
      required int second,
      dynamic Function(File?)? onComplete}) async {
    var videoPathSplit = videoPath.split("\\");
    if (videoPathSplit.isEmpty) return;
    var videoOutput = path.join(_savedVideoPath,
        "Preprocess_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss")}.mp4");
    int scaledWidth = roundToNearestEven(width);
    int scaledHeight = roundToNearestEven(height);
    await FFMpegHelper.instance.runAsync(
        FFMpegCommand(outputFilepath: videoOutput, inputs: [
          FFMpegInput([
            '-i',
            videoPath,
            '-filter_complex',
            '[0:v]fps=$_videoOutputFps,scale=$scaledWidth:$scaledHeight:force_original_aspect_ratio=increase[scaled];[scaled]crop=$scaledWidth:$scaledHeight[cropped];[cropped]hflip',
            '-ss',
            '1',
            '-t',
            '$second',
            "-c:v",
            "libx264",
            "-preset",
            "ultrafast",
            "-crf",
            "$_videoCrf",
            "-pix_fmt",
            "yuv420p",
            "-an",
            "-movflags",
            "+faststart",
            "-threads",
            "$_videoMergeThreads",
            '-y',
          ]),
        ]),
        onComplete: onComplete);
  }

  Future<File?> encodeLiveViewFrames({
    required String framePattern,
    required int fps,
  }) async {
    final videoOutput = path.join(_savedVideoPath,
        "LiveView_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm_ss")}.mp4");
    return FFMpegHelper.instance.runSync(
      FFMpegCommand(outputFilepath: videoOutput, inputs: [
        FFMpegInput([
          '-framerate',
          '$fps',
          '-i',
          framePattern,
          '-r',
          '$_videoOutputFps',
          '-c:v',
          'libx264',
          '-preset',
          'ultrafast',
          '-crf',
          '$_videoCrf',
          '-pix_fmt',
          'yuv420p',
          '-an',
          '-movflags',
          '+faststart',
        ]),
      ]),
    );
  }

  static int roundToNearestEven(double value) {
    int rounded = value.ceil();
    if (rounded.isEven) {
      return rounded.toInt();
    } else {
      if (value > 0) {
        return ((rounded + 1) + 6.w).toInt();
      } else {
        return ((rounded - 1) + 6.w).toInt();
      }
    }
  }
}

// scenery_output.jpeg
