import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:project_l/common/enums/printer_cut_mode.dart';
import 'package:project_l/common/extensions/size_extension.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/common/util/frame_overlay_mask_utils.dart';
import 'package:project_l/common/util/ffmpeg_utils.dart' show FfmpegUtils;
import 'package:project_l/common/util/printer_utils.dart';
import 'package:project_l/common/util/qr_utils.dart';
import 'package:project_l/features/printing/provider/printing_screen_listen_state.dart';

@injectable
class PrintingScreenProvider extends BaseProvider<PrintingScreenListenState> {
  final FfmpegUtils _ffmpegUtils;
  final PrinterUtils _printerUtils;
  final QrUtils _qrUtils;
  final FrameOverlayMaskUtils _frameOverlayMaskUtils = FrameOverlayMaskUtils();
  Uint8List qrCode = Uint8List.fromList([]);
  String finalPrintImagePath = '';
  String qrUrl = '';
  String preparationStatus = '';
  bool isUploadQueued = false;

  PrintingScreenProvider(this._ffmpegUtils, this._printerUtils, this._qrUtils);

  String _resolveSceneBackgroundPath(String frameOverlayPath) {
    final selectedBackground = appState.imageParam.selectedBackground;
    final backgroundPath = selectedBackground.bgUrl ?? '';
    if (backgroundPath.isNotEmpty && File(backgroundPath).existsSync()) {
      return backgroundPath;
    }

    final frameBackgroundInfo =
        appState.imageParam.selectedFrame.backgroundInfo ?? [];
    for (final category in frameBackgroundInfo) {
      for (final background in category.background ?? []) {
        final candidate = background.bgUrl ?? '';
        if (candidate.isNotEmpty && File(candidate).existsSync()) {
          logD('Printing background fallback: $candidate');
          return candidate;
        }
      }
    }

    logE('Printing background missing, fallback to frame overlay');
    return frameOverlayPath;
  }

  Future<bool> exportFiles() async {
    qrCode = Uint8List.fromList([]);
    qrUrl = '';
    finalPrintImagePath = '';
    preparationStatus = 'Preparing print image...';
    isUploadQueued = false;
    notifyListeners();
    logD('Printing export start');
    try {
      final bgTransparentAreas =
          appState.imageParam.selectedBackground.getTransparentAreas();
      final frameInfo = appState.imageParam.selectedFrame;
      var transparent = bgTransparentAreas.isNotEmpty
          ? bgTransparentAreas
          : frameInfo.getDisplayTransparentAreas(
              fallbackCount:
                  frameInfo.frameSetting?.numOfPhotos ?? 0,
            );

      if (transparent.isEmpty) {
        preparationStatus = 'No printable photo slots found';
        notifyListeners();
        logD('Printing export stopped: transparent areas empty');
        return false;
      }

      // Trim transparent to match images count — same guard as background selection preview.
      // Prevents _validateImageMergeInputs from throwing when slot count != photo count.
      final slotCount = min(transparent.length, appState.imageParam.images.length);
      transparent = transparent.sublist(0, slotCount);
      final params = appState.imageParam.pansAndScales.length >= slotCount
          ? appState.imageParam.pansAndScales.sublist(0, slotCount)
          : appState.imageParam.pansAndScales;

      var printingImage = "";
      var uploadImage = "";

      var isCut = appState.imageParam.selectedFrame.isCut();
      final frameOverlaySourcePath =
          appState.imageParam.selectedFrame.frameUrlTempDis ??
              appState.imageParam.selectedFrame.frameUrl ??
              '';
      final frameOverlayPath =
          await _frameOverlayMaskUtils.resolveMaskedOverlayPath(
        frameOverlaySourcePath,
      );
      final backgroundPath =
          _resolveSceneBackgroundPath(frameOverlaySourcePath);
      if (appState.isMockPaymentMode) {
        final mockImage = _resolveMockPrintImage(
          backgroundPath: backgroundPath,
          frameOverlayPath: frameOverlayPath,
          frameOverlaySourcePath: frameOverlaySourcePath,
        );
        finalPrintImagePath = mockImage;
        uploadImage = mockImage;
        final mockVideoPaths = _resolveMockVideoPaths();
        preparationStatus = 'Saving upload for later...';
        notifyListeners();
        logD(
          'Printing mock export image: $mockImage videos=${mockVideoPaths.length}',
        );
        final response = await appState.submitOrQueueResult(
            saleNo: appState.imageParam.session,
            cuKey: appState.imageParam.couponCode,
            frameId: appState.imageParam.selectedFrame.frameCd ?? '',
            imagePath: uploadImage,
            videoPaths: mockVideoPaths,
            amount: appState.imageParam.selectedFrame.price ?? 0,
            printQuantity: appState.imageParam.printQuantity,
            uploadNow: false);

        qrUrl = _resolveQrUrl(response?.qrUrl);
        isUploadQueued = response == null;
        if (qrUrl.isNotEmpty) {
          preparationStatus = 'Generating QR...';
          notifyListeners();
          qrCode = await _qrUtils.generateQr(
            encodedString: qrUrl,
            size: 250,
          );
        }
        preparationStatus =
            isUploadQueued ? 'Waiting to upload when online' : '';
        logD(
          'Printing mock export done: queued=$isUploadQueued qrUrl=${qrUrl.isNotEmpty}',
        );
        notifyListeners();
        return true;
      }

      preparationStatus = 'Preparing selected photos...';
      notifyListeners();
      final allPreprocessedImages = await _preprocessPrintImages();

      // Take final effective count as min of ALL three inputs so
      // _validateImageMergeInputs never sees a length mismatch.
      final effectiveCount = [
        transparent.length,
        allPreprocessedImages.length,
        params.length,
      ].reduce(min);
      final preprocessedImages = allPreprocessedImages.sublist(0, effectiveCount);
      transparent = transparent.sublist(0, effectiveCount);
      final effectiveParams = params.sublist(0, effectiveCount);

      if (isCut) {
        preparationStatus = 'Preparing printer cut mode...';
        notifyListeners();
        logD('Printing change cut mode: twoInch');
        final cutModeChanged =
            await _printerUtils.changeCutMode(PrinterCutMode.twoInch);
        if (!cutModeChanged) {
          logE('Printing change cut mode failed: twoInch');
        }

        preparationStatus = 'Merging print image...';
        notifyListeners();
        logD('Printing merge upload image start');
        uploadImage = await _ffmpegUtils.mergeImage(
            backgroundPath: backgroundPath,
            frameOverlayPath: backgroundPath,
            images: preprocessedImages,
            transparents: transparent,
            params: effectiveParams,
            flip: appState.imageParam.isFlipped);
        logD('Printing merge upload image done: $uploadImage');
        printingImage =
            await _ffmpegUtils.mergeHorizontalImage(imagePath: uploadImage);
        logD('Printing cut print image (hstack): $printingImage');
      } else {
        preparationStatus = 'Preparing printer cut mode...';
        notifyListeners();
        logD('Printing change cut mode: standard');
        final cutModeChanged =
            await _printerUtils.changeCutMode(PrinterCutMode.standard);
        if (!cutModeChanged) {
          logE('Printing change cut mode failed: standard');
        }

        preparationStatus = 'Merging print image...';
        notifyListeners();
        logD('Printing merge print image start');
        printingImage = await _ffmpegUtils.mergeImage(
            backgroundPath: backgroundPath,
            frameOverlayPath: backgroundPath,
            images: preprocessedImages,
            transparents: transparent,
            params: effectiveParams,
            flip: appState.imageParam.isFlipped);
        logD('Printing merge print image done: $printingImage');
        uploadImage = printingImage;
      }

      finalPrintImagePath = printingImage;
      notifyListeners();

      final videoPaths = await _prepareVideoPaths(
        backgroundPath: backgroundPath,
        frameOverlayPath: frameOverlayPath,
        uploadImage: uploadImage,
        transparents: transparent,
      );

      preparationStatus = 'Saving upload for later...';
      notifyListeners();
      logD('Printing queue upload start');
      final response = await appState.submitOrQueueResult(
          saleNo: appState.imageParam.session,
          cuKey: appState.imageParam.couponCode,
          frameId: appState.imageParam.selectedFrame.frameCd ?? '',
          imagePath: uploadImage,
          videoPaths: videoPaths,
          amount: appState.imageParam.selectedFrame.price ?? 0,
          printQuantity: appState.imageParam.printQuantity,
          uploadNow: false);

      qrUrl = _resolveQrUrl(response?.qrUrl);
      isUploadQueued = response == null;
      if (qrUrl.isNotEmpty) {
        preparationStatus = 'Generating QR...';
        notifyListeners();
        qrCode = await _qrUtils.generateQr(
          encodedString: qrUrl,
          size: 250,
        );
        if (qrCode.isNotEmpty) {
          logD('Printing overlay QR on print image start');
          printingImage = await _ffmpegUtils.overlayQrOnImage(
            imagePath: printingImage,
            qrBytes: qrCode,
          );
          logD('Printing overlay QR done: $printingImage');
        }
      }
      preparationStatus = isUploadQueued ? 'Waiting to upload when online' : '';
      logD(
        'Printing queue upload done: queued=$isUploadQueued qrUrl=${qrUrl.isNotEmpty}',
      );
      notifyListeners();

      try {
        preparationStatus = 'Sending print job...';
        notifyListeners();
        var size = appState.imageParam.selectedFrame.getSize();
        final printCopies = _resolvePrintCopies(isCut: isCut);
        logD('Printing print job start: $printingImage');
        final printQueued = await _printerUtils
            .printImage(
              file: File(printingImage),
              numCut: printCopies,
              orientation: Size(size.$1, size.$2).orientation,
            )
            .timeout(
              const Duration(seconds: 45),
              onTimeout: () => false,
            );
        logD(
          'Printing print job done: queued=$printQueued copies=$printCopies',
        );
        appState.updatePrinterConnectionStatus(connected: true);
        appState.sendPrinterStatusReport();
      } catch (error, stackTrace) {
        logE(error, stackTrace: stackTrace);
        appState.updatePrinterConnectionStatus(
          connected: false,
          errorCode: 'PRINT_FAILED',
        );
        appState.sendPrinterStatusReport();
      }
      preparationStatus = isUploadQueued ? 'Waiting to upload when online' : '';
      notifyListeners();
      return true;
    } catch (error, stackTrace) {
      final detail = error is StateError ? error.message : error.toString();
      preparationStatus = 'Error: $detail';
      isUploadQueued = false;
      logE(error, stackTrace: stackTrace);
      notifyListeners();
      return false;
    }
    //
    // for (var video in appState.imageParam.videos) {
    //   var file = File(video);
    //   if (file.existsSync()) {
    //     file.deleteSync();
    //   }
    // }
    //
    // for (var image in appState.imageParam.images) {
    //   var file = File(image);
    //   if (file.existsSync()) {
    //     file.deleteSync();
    //   }
    // }
  }

  Future<List<String>> _preprocessPrintImages() async {
    final results = <String>[];
    final images = appState.imageParam.images;
    for (var index = 0; index < images.length; index++) {
      final imagePath = images[index];
      final stopwatch = Stopwatch()..start();
      logD(
        'Printing preprocess image start: ${index + 1}/${images.length} $imagePath',
      );
      final outputPath = await _ffmpegUtils.preprocessImage(
        imagePath: imagePath,
        effect: appState.imageParam.effect,
        filter: appState.imageParam.colorFilter,
        isFlip: appState.imageParam.isFlipped,
      );
      if (outputPath.isEmpty || !File(outputPath).existsSync()) {
        throw StateError('Could not preprocess print image: $imagePath');
      }
      logD(
        'Printing preprocess image done: ${index + 1}/${images.length} '
        'elapsed=${stopwatch.elapsedMilliseconds}ms output=$outputPath',
      );
      results.add(outputPath);
    }
    return results;
  }

  String _resolveMockPrintImage({
    required String backgroundPath,
    required String frameOverlayPath,
    required String frameOverlaySourcePath,
  }) {
    final candidates = [
      backgroundPath,
      frameOverlayPath,
      frameOverlaySourcePath,
      ...appState.imageParam.images,
    ];
    for (final candidate in candidates) {
      if (candidate.isNotEmpty && File(candidate).existsSync()) {
        return candidate;
      }
    }
    return '';
  }

  List<String> _resolveMockVideoPaths() {
    return appState.imageParam.videos
        .where((path) => path.isNotEmpty && File(path).existsSync())
        .toList();
  }

  String _resolveQrUrl(String? apiQrUrl) {
    final normalizedApiQrUrl = apiQrUrl?.trim() ?? '';
    if (normalizedApiQrUrl.isNotEmpty) {
      return normalizedApiQrUrl;
    }

    final baseUrl = appState.remoteApiBaseUrl.trim();
    final saleNo = appState.imageParam.session.trim();
    if (baseUrl.isEmpty || saleNo.isEmpty) {
      return '';
    }
    return '${baseUrl.replaceFirst(RegExp(r'/+$'), '')}/pub/results/$saleNo';
  }

  List<String> _resolveSelectedVideoPaths() {
    final supportedExtensions = {'.mp4', '.mov', '.webm', '.mkv', '.avi'};
    return appState.imageParam.videos.where((videoPath) {
      if (videoPath.isEmpty || !File(videoPath).existsSync()) {
        return false;
      }
      final extension = videoPath.split('.').lastOrNull?.trim().toLowerCase();
      return extension != null && supportedExtensions.contains('.$extension');
    }).toList();
  }

  Future<List<String>> _prepareVideoPaths({
    required String backgroundPath,
    required String frameOverlayPath,
    required String uploadImage,
    required List<List<double>> transparents,
  }) async {
    final mode = appState.videoExportMode;
    final videoPaths = <String>[];
    try {
      if (mode == 'skip') {
        logD('Printing video skipped by config');
        return videoPaths;
      }

      if (mode == 'slideshow') {
        preparationStatus = 'Preparing lightweight video...';
        notifyListeners();
        logD('Printing slideshow video start: image=$uploadImage');
        final slideshowVideo = await _ffmpegUtils
            .createLightweightSlideshowVideo(
          imagePath: uploadImage,
        );
        videoPaths.add(slideshowVideo);
        logD('Printing slideshow video done: $slideshowVideo');
        return videoPaths;
      }

      final selectedVideos = _resolveSelectedVideoPaths();
      if (selectedVideos.isEmpty) {
        logE(
          'Printing merge video skipped: no valid video files '
          'from ${appState.imageParam.videos.length} selected paths',
        );
        return videoPaths;
      }

      preparationStatus = 'Preparing video...';
      notifyListeners();
      logD('Printing merge video start: videos=${selectedVideos.length}');
      final mergedVideo = await _ffmpegUtils.mergeVideo(
          backgroundPath: backgroundPath,
          frameOverlayPath: frameOverlayPath,
          videos: selectedVideos,
          transparents: transparents,
          params: appState.imageParam.pansAndScales,
          flip: appState.imageParam.isFlipped);
      videoPaths.add(mergedVideo);
      logD('Printing merge video done: $mergedVideo');
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      logE('Printing video export failed, continue with image only');
    }
    return videoPaths;
  }

  int _resolvePrintCopies({required bool isCut}) {
    final quantity = appState.imageParam.printQuantity;
    final copies = isCut ? (quantity / 2).ceil() : quantity;
    return copies < 1 ? 1 : copies;
  }
}
