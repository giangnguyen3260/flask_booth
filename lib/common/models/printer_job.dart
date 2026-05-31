import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_l/common/enums/printer_job_status.dart';

part 'printer_job.freezed.dart';

@freezed
class PrinterJob with _$PrinterJob {
  const factory PrinterJob({
    @JsonKey(name: "JobId") @Default(-1) int jobId,
    @Default(PrinterJobStatus.unknown)
    PrinterJobStatus status,
    @JsonKey(name: "Document") @Default("") String document,
    @JsonKey(name: "User") @Default("") String user,
    @JsonKey(name: "Printer") @Default("") String printer,
    @JsonKey(name: "PagesPrinted") @Default(-1) int pagesPrinted,
    @JsonKey(name: "TotalPages") @Default(-1) int totalPages,
  }) = _PrinterJob;

  factory PrinterJob.fromJson(Map<String, Object?> json){
    return PrinterJob(
      jobId: (json['JobId'] as num?)?.toInt() ?? -1,
      status: PrinterJobStatus.fromValue((json['Status'] as num?)?.toInt() ?? -1),
      document: json['Document'] as String? ?? "",
      user: json['User'] as String? ?? "",
      printer: json['Printer'] as String? ?? "",
      pagesPrinted: (json['PagesPrinted'] as num?)?.toInt() ?? -1,
      totalPages: (json['TotalPages'] as num?)?.toInt() ?? -1,
    );
  }
}
