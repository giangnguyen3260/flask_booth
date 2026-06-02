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
    isUploadQueued = false;
    notifyListeners();

    var transparent =
        appState.imageParam.selectedFrame.getDisplayTransparentAreas(
      fallbackCount:
          appState.imageParam.selectedFrame.frameSetting?.numOfPhotos ?? 0,
    );

    if (transparent.isEmpty) {
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
    final backgroundPath = _resolveSceneBackgroundPath(frameOverlaySourcePath);
    if (isCut) {
      await _printerUtils.changeCutMode(PrinterCutMode.twoInch);

      uploadImage = await _ffmpegUtils.mergeImage(
          backgroundPath: backgroundPath,
          frameOverlayPath: frameOverlayPath,
          images: await Future.wait(preprocessedImages),
          transparents: transparent,
          params: appState.imageParam.pansAndScales,
          flip: appState.imageParam.isFlipped);
      printingImage =
          await _ffmpegUtils.mergeHorizontalImage(imagePath: uploadImage);
    } else {
      await _printerUtils.changeCutMode(PrinterCutMode.standard);

      printingImage = await _ffmpegUtils.mergeImage(
          backgroundPath: backgroundPath,
          frameOverlayPath: frameOverlayPath,
          images: await Future.wait(preprocessedImages),
          transparents: transparent,
          params: appState.imageParam.pansAndScales,
          flip: appState.imageParam.isFlipped);
      uploadImage = printingImage;
    }

    finalPrintImagePath = printingImage;
    notifyListeners();

    var size = appState.imageParam.selectedFrame.getSize();
    _printerUtils.printImage(
        file: File(printingImage),
        numCut: isCut
            ? (appState.imageParam.printQuantity / 2).toInt()
            : appState.imageParam.printQuantity,
        orientation: Size(size.$1, size.$2).orientation);

    final videoPaths = <String>[];
    if (appState.imageParam.videos.isNotEmpty) {
      var mergedVideo = await _ffmpegUtils.mergeVideo(
          backgroundPath: backgroundPath,
          frameOverlayPath: frameOverlayPath,
          videos: appState.imageParam.videos,
          transparents: transparent,
          params: appState.imageParam.pansAndScales,
          flip: appState.imageParam.isFlipped);
      videoPaths.add(mergedVideo);
    }

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
      qrCode = await _qrUtils.generateQr(
        encodedString: response?.qrUrl ?? '',
        size: 250,
      );
    }
    notifyListeners();
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
}
