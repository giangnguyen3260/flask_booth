import 'dart:io';
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

  Future<void> exportFiles() async {
    qrCode = Uint8List.fromList([]);
    qrUrl = '';
    finalPrintImagePath = '';
    preparationStatus = 'Preparing print image...';
    isUploadQueued = false;
    notifyListeners();
    logD('Printing export start');
    try {
      var transparent =
          appState.imageParam.selectedFrame.getDisplayTransparentAreas(
        fallbackCount:
            appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 0,
      );

      if (transparent.isEmpty) {
        preparationStatus = 'No printable photo slots found';
        notifyListeners();
        logD('Printing export stopped: transparent areas empty');
        return;
      }

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

        qrUrl = response?.qrUrl ?? '';
        isUploadQueued = response == null;
        if (response?.qrUrl?.isNotEmpty ?? false) {
          preparationStatus = 'Generating QR...';
          notifyListeners();
          qrCode = await _qrUtils.generateQr(
            encodedString: response?.qrUrl ?? '',
            size: 250,
          );
        }
        preparationStatus =
            isUploadQueued ? 'Waiting to upload when online' : '';
        logD(
          'Printing mock export done: queued=$isUploadQueued qrUrl=${qrUrl.isNotEmpty}',
        );
        notifyListeners();
        return;
      }

      preparationStatus = 'Preparing selected photos...';
      notifyListeners();
      final preprocessedImages = await _preprocessPrintImages();

      if (isCut) {
        preparationStatus = 'Preparing printer cut mode...';
        notifyListeners();
        logD('Printing change cut mode: twoInch');
        await _printerUtils.changeCutMode(PrinterCutMode.twoInch);

        preparationStatus = 'Merging print image...';
        notifyListeners();
        logD('Printing merge upload image start');
        uploadImage = await _ffmpegUtils.mergeImage(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            images: preprocessedImages,
            transparents: transparent,
            params: appState.imageParam.pansAndScales,
            flip: appState.imageParam.isFlipped);
        logD('Printing merge upload image done: $uploadImage');
        printingImage = uploadImage;
        logD('Printing cut print image uses upload image: $printingImage');
      } else {
        preparationStatus = 'Preparing printer cut mode...';
        notifyListeners();
        logD('Printing change cut mode: standard');
        await _printerUtils.changeCutMode(PrinterCutMode.standard);

        preparationStatus = 'Merging print image...';
        notifyListeners();
        logD('Printing merge print image start');
        printingImage = await _ffmpegUtils.mergeImage(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            images: preprocessedImages,
            transparents: transparent,
            params: appState.imageParam.pansAndScales,
            flip: appState.imageParam.isFlipped);
        logD('Printing merge print image done: $printingImage');
        uploadImage = printingImage;
      }

      finalPrintImagePath = printingImage;
      notifyListeners();

      final selectedVideos = _resolveSelectedVideoPaths();
      final videoPaths = <String>[];
      if (selectedVideos.isNotEmpty) {
        preparationStatus = 'Preparing video...';
        notifyListeners();
        logD('Printing merge video start: videos=${selectedVideos.length}');
        var mergedVideo = await _ffmpegUtils.mergeVideo(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            videos: selectedVideos,
            transparents: transparent,
            params: appState.imageParam.pansAndScales,
            flip: appState.imageParam.isFlipped);
        videoPaths.add(mergedVideo);
        logD('Printing merge video done: $mergedVideo');
      } else {
        logE(
          'Printing merge video skipped: no valid video files '
          'from ${appState.imageParam.videos.length} selected paths',
        );
      }

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

      qrUrl = response?.qrUrl ?? '';
      isUploadQueued = response == null;
      if (response?.qrUrl?.isNotEmpty ?? false) {
        preparationStatus = 'Generating QR...';
        notifyListeners();
        qrCode = await _qrUtils.generateQr(
          encodedString: response?.qrUrl ?? '',
          size: 250,
        );
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
      } catch (error, stackTrace) {
        logE(error, stackTrace: stackTrace);
      }
      preparationStatus = isUploadQueued ? 'Waiting to upload when online' : '';
      notifyListeners();
    } catch (error, stackTrace) {
      preparationStatus = 'Could not prepare print image';
      isUploadQueued = false;
      logE(error, stackTrace: stackTrace);
      notifyListeners();
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

  int _resolvePrintCopies({required bool isCut}) {
    final quantity = appState.imageParam.printQuantity;
    final copies = isCut ? (quantity / 2).ceil() : quantity;
    return copies < 1 ? 1 : copies;
  }
}
