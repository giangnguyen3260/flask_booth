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
    if (backgroundPath.isNotEmpty) {
      return backgroundPath;
    }
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
        preparationStatus = 'Uploading result...';
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
            printQuantity: appState.imageParam.printQuantity);

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

      List<Future<String>> preprocessedImages = [];

      for (var e in appState.imageParam.images) {
        preprocessedImages.add(
          _ffmpegUtils.preprocessImage(
            imagePath: e,
            effect: appState.imageParam.effect,
            filter: appState.imageParam.colorFilter,
            isFlip: appState.imageParam.isFlipped,
          ),
        );
      }

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
            images: await Future.wait(preprocessedImages),
            transparents: transparent,
            params: appState.imageParam.pansAndScales,
            flip: appState.imageParam.isFlipped);
        logD('Printing merge upload image done: $uploadImage');
        preparationStatus = 'Preparing cut print image...';
        notifyListeners();
        printingImage =
            await _ffmpegUtils.mergeHorizontalImage(imagePath: uploadImage);
        logD('Printing merge horizontal image done: $printingImage');
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
            images: await Future.wait(preprocessedImages),
            transparents: transparent,
            params: appState.imageParam.pansAndScales,
            flip: appState.imageParam.isFlipped);
        logD('Printing merge print image done: $printingImage');
        uploadImage = printingImage;
      }

      finalPrintImagePath = printingImage;
      preparationStatus = 'Sending print job...';
      notifyListeners();

      var size = appState.imageParam.selectedFrame.getSize();
      logD('Printing print job start: $printingImage');
      _printerUtils.printImage(
          file: File(printingImage),
          numCut: isCut
              ? (appState.imageParam.printQuantity / 2).toInt()
              : appState.imageParam.printQuantity,
          orientation: Size(size.$1, size.$2).orientation);
      logD('Printing print job queued');

      final videoPaths = <String>[];
      if (appState.imageParam.videos.isNotEmpty) {
        preparationStatus = 'Preparing video...';
        notifyListeners();
        logD('Printing merge video start');
        var mergedVideo = await _ffmpegUtils.mergeVideo(
            backgroundPath: backgroundPath,
            frameOverlayPath: frameOverlayPath,
            videos: appState.imageParam.videos,
            transparents: transparent,
            params: appState.imageParam.pansAndScales,
            flip: appState.imageParam.isFlipped);
        videoPaths.add(mergedVideo);
        logD('Printing merge video done: $mergedVideo');
      }

      preparationStatus = 'Uploading result...';
      notifyListeners();
      logD('Printing submit/upload start');
      final response = await appState.submitOrQueueResult(
          saleNo: appState.imageParam.session,
          cuKey: appState.imageParam.couponCode,
          frameId: appState.imageParam.selectedFrame.frameCd ?? '',
          imagePath: uploadImage,
          videoPaths: videoPaths,
          amount: appState.imageParam.selectedFrame.price ?? 0,
          printQuantity: appState.imageParam.printQuantity);

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
        'Printing export done: queued=$isUploadQueued qrUrl=${qrUrl.isNotEmpty}',
      );
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
}
