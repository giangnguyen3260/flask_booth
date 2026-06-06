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
    final doc = pw.Document();

    Uint8List bytes = file.readAsBytesSync();

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
    final printers = await Printing.listPrinters();
    print('PrinterUtils.availablePrinters=${printers.map((e) => e.name).join(', ')}');
    Printer printer = printers.lastWhere(
      (e) => e.name.contains(PrinterConstants.printerName),
    );
    print('PrinterUtils.selectedPrinter=${printer.name}');

    for (int i = 0; i < numCut; i++) {
      print('PrinterUtils.directPrintPdf copy=${i + 1}/$numCut');
      await Printing.directPrintPdf(
        format: format,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => doc.save(),
        printer: printer,
      );
    }

    while ((await getJobQueue()).isNotEmpty) {
      await Future.delayed(
        const Duration(milliseconds: 1500),
      );
    }
    return true;
  }

  /*
  * This function is used to change printer setting
  * */
  Future<bool> changeCutMode(PrinterCutMode cutMode) async {
    print('PrinterUtils.changeCutMode skipped: $cutMode');
    return true;

    String executablePath = Platform.resolvedExecutable;
    String executableDir = path.dirname(executablePath);
    String cmd =
        'printui.dll,PrintUIEntry /Sr /n "${PrinterConstants.printerName}" /a ';
    switch (cutMode) {
      case PrinterCutMode.standard:
        cmd += '"$executableDir\\${_normalCutPath.replaceAll("/", "\\")}"';
        break;
      case PrinterCutMode.twoInch:
        cmd += '"$executableDir/${_twoInchCutPath.replaceAll("/", "\\")}"';
        break;
    }
    print("$cmd u");
    return await _printerMethodChannel.invokeMethod<bool>("change_mode", {
      "command": "$cmd u",
    }) ??
        false;
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
