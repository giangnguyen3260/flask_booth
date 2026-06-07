import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:project_l/common/constants/printer_constants.dart';
import 'package:project_l/common/constants/printer_method_channel_constants.dart';
import 'package:project_l/common/enums/orientation_enum.dart';
import 'package:project_l/common/enums/printer_cut_mode.dart';
import 'package:project_l/common/enums/printer_job_action.dart';
import 'package:project_l/common/enums/printer_paper_size.dart';
import 'package:project_l/common/models/printer_job.dart';
import 'package:project_l/gen/assets.gen.dart';
import 'package:path/path.dart' as path;

@Singleton()
class PrinterUtils {
  late final String _twoInchCutPath = Assets.files.a2inchCut;
  late final String _normalCutPath = Assets.files.normalCut;
  final MethodChannel _printerMethodChannel =
      MethodChannel(PrinterMethodChannelConstants.methodChannelName);

  Future<bool> printImage({
    required File file,
    PdfPageFormat format = PrinterConstants.p6x4Format,
    int numCut = 0,
    required OrientationEnum orientation,
  }) async {
    print('PrinterUtils.printImage file=${file.path} copies=$numCut');
    if (!file.existsSync()) {
      print('PrinterUtils.printImage missing file=${file.path}');
      return false;
    }
    final copies = numCut < 1 ? 1 : numCut;
    final doc = pw.Document();

    Uint8List bytes = await file.readAsBytes();

    doc.addPage(
      pw.Page(
        orientation: orientation == OrientationEnum.portrait
            ? pw.PageOrientation.portrait
            : pw.PageOrientation.landscape,
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Image(
            pw.MemoryImage(
              bytes,
            ),
          );
        },
      ),
    );
    final pdfBytes = await doc.save();
    final printers = await Printing.listPrinters().timeout(
      const Duration(seconds: 8),
    );
    print(
      'PrinterUtils.availablePrinters=${printers.map((e) => e.name).join(', ')}',
    );
    final matches =
        printers.where((e) => e.name.contains(PrinterConstants.printerName));
    if (matches.isEmpty) {
      print('PrinterUtils.selectedPrinter not found');
      return false;
    }
    final printer = matches.last;
    print('PrinterUtils.selectedPrinter=${printer.name}');

    for (int i = 0; i < copies; i++) {
      print('PrinterUtils.directPrintPdf copy=${i + 1}/$copies');
      await Future.value(Printing.directPrintPdf(
        format: format,
        usePrinterSettings: false,
        onLayout: (PdfPageFormat format) async => pdfBytes,
        printer: printer,
      )).timeout(
        const Duration(seconds: 20),
      );
    }

    await _waitForPrinterQueue(maxAttempts: 8);
    return true;
  }

  Future<void> _waitForPrinterQueue({required int maxAttempts}) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final jobs = await getJobQueue().timeout(const Duration(seconds: 3));
        print('PrinterUtils.queue attempt=${attempt + 1} jobs=${jobs.length}');
        if (jobs.isEmpty) {
          return;
        }
      } catch (error) {
        print('PrinterUtils.queue check failed: $error');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 1500));
    }
    print('PrinterUtils.queue wait timeout');
  }

  /*
  * This function is used to change printer setting
  * */
  Future<bool> changeCutMode(PrinterCutMode cutMode) async {
    final presetPath = _resolveAssetFile(
      cutMode == PrinterCutMode.standard ? _normalCutPath : _twoInchCutPath,
    );
    if (!File(presetPath).existsSync()) {
      print('PrinterUtils.changeCutMode missing preset: $presetPath');
      return false;
    }

    String cmd =
        'printui.dll,PrintUIEntry /Sr /n "${PrinterConstants.printerName}" /a ';
    switch (cutMode) {
      case PrinterCutMode.standard:
        cmd += '"$presetPath"';
        break;
      case PrinterCutMode.twoInch:
        cmd += '"$presetPath"';
        break;
    }
    final command = '$cmd u';
    print('PrinterUtils.changeCutMode mode=$cutMode command=$command');
    final result =
        await _printerMethodChannel.invokeMethod<bool>("change_mode", {
              "command": command,
            }).timeout(const Duration(seconds: 30)) ??
            false;
    print('PrinterUtils.changeCutMode result=$result mode=$cutMode');
    return result;
  }

  String _resolveAssetFile(String assetPath) {
    if (File(assetPath).existsSync()) {
      return path.normalize(assetPath);
    }
    final executableDir = path.dirname(Platform.resolvedExecutable);
    final bundledPath = path.joinAll([
      executableDir,
      'data',
      'flutter_assets',
      ...assetPath.split('/'),
    ]);
    if (File(bundledPath).existsSync()) {
      return path.normalize(bundledPath);
    }
    return path.normalize(assetPath);
  }

  /*
   * Change paper size of printer
   */
  Future<bool> changePaperSize({
    required PrinterPaperSize size,
  }) async {
    return await _printerMethodChannel.invokeMethod(
      PrinterMethodChannelConstants.changeSizeMethod,
      {
        "printer_name": PrinterConstants.printerName,
        "size": size.paperSize,
      },
    );
  }

  /*
   * Get all print job
   */
  Future<List<PrinterJob>> getJobQueue() async {
    List<Object?> data = await _printerMethodChannel.invokeMethod(
      PrinterMethodChannelConstants.jobQueueMethod,
      {
        "printer_name": PrinterConstants.printerName,
      },
    );

    List<PrinterJob> jobs = [];

    for (int i = 0; i < data.length; i++) {
      PrinterJob printerJob =
          PrinterJob.fromJson((data[i] as Map).cast<String, dynamic>());
      jobs.add(printerJob);
    }

    return jobs;
  }

  /*
   * Perform an operation on a print job
   */
  Future<bool> jobAction({
    required PrinterJobAction action,
    required int jobId,
  }) async {
    return await _printerMethodChannel.invokeMethod(
      PrinterMethodChannelConstants.jobOperationMethod,
      {
        "printer_name": PrinterConstants.printerName,
        "job_id": jobId,
        "operation": action.value,
      },
    );
  }
}
