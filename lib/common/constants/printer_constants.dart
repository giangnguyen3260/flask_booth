import 'package:pdf/pdf.dart';

class PrinterConstants {
  static String printerName = "DS-RX1";
  static const PdfPageFormat p6x4Format = PdfPageFormat(
    156.1 * PdfPageFormat.mm,
    105.0 * PdfPageFormat.mm,
  );
}
