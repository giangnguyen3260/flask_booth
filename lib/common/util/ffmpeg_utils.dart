import 'dart:async';
import 'dart:io';

import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  static const Duration _videoMergeTimeout = Duration(minutes: 8);
  static const int _imageMergeThreads = 1;
  static const int _videoMergeThreads = 1;
  static const int _videoOutputFps = 10;
  static const int _videoCrf = 28;

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
    var imageOutput = path.join(_savedImagePath,
        "Output_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm")}.png");

    final outputFile = await FFMpegHelper.instance.runSync(
      FFMpegCommand(outputFilepath: imageOutput, inputs: [
        FFMpegInput([
          ...generateOverlayCommand(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            images: images,
            transparents: transparents,
            params: params,
            flip: !flip,
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

  Future<String> mergeVideo(
      {required String backgroundPath,
      required String frameOverlayPath,
      required List<String> videos,
      required List<List<double>> transparents,
      required List<MatrixParam> params,
      required bool flip}) async {
    var videoOutput = path.join(_savedVideoPath,
        "Output_${DateTimeUtils.format(date: DateTime.now(), format: "dd_MM_yyyy_HH_mm")}.mp4");

    final outputFile = await FFMpegHelper.instance.runSync(
      FFMpegCommand(outputFilepath: videoOutput, inputs: [
        FFMpegInput([
          ...generateOverlayCommand(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            images: videos,
            transparents: transparents,
            params: params,
            flip: flip,
            threadCount: _videoMergeThreads,
            fps: _videoOutputFps,
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
        ]),
      ]),
      timeout: _videoMergeTimeout,
    );
    if (outputFile == null || !outputFile.existsSync()) {
      throw StateError('FFmpeg video merge failed: $videoOutput');
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
      final fpsPrefix = fps == null ? '' : 'fps=$fps,';
      if (flip) {
        filterComplex += '$currentInput ${fpsPrefix}hflip$flipped;';
        filterComplex += '$flipped scale=iw*$scaleX:ih*$scaleY$scaled;';
      } else {
        filterComplex +=
            '$currentInput ${fpsPrefix}scale=iw*$scaleX:ih*$scaleY$scaled;';
      }
      filterComplex += '$scaled crop=$cropW:$cropH:$cropX:$cropY$cropped;';
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
