// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PrinterJob {
  @JsonKey(name: "JobId")
  int get jobId => throw _privateConstructorUsedError;
  PrinterJobStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: "Document")
  String get document => throw _privateConstructorUsedError;
  @JsonKey(name: "User")
  String get user => throw _privateConstructorUsedError;
  @JsonKey(name: "Printer")
  String get printer => throw _privateConstructorUsedError;
  @JsonKey(name: "PagesPrinted")
  int get pagesPrinted => throw _privateConstructorUsedError;
  @JsonKey(name: "TotalPages")
  int get totalPages => throw _privateConstructorUsedError;

  /// Create a copy of PrinterJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterJobCopyWith<PrinterJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterJobCopyWith<$Res> {
  factory $PrinterJobCopyWith(
          PrinterJob value, $Res Function(PrinterJob) then) =
      _$PrinterJobCopyWithImpl<$Res, PrinterJob>;
  @useResult
  $Res call(
      {@JsonKey(name: "JobId") int jobId,
      PrinterJobStatus status,
      @JsonKey(name: "Document") String document,
      @JsonKey(name: "User") String user,
      @JsonKey(name: "Printer") String printer,
      @JsonKey(name: "PagesPrinted") int pagesPrinted,
      @JsonKey(name: "TotalPages") int totalPages});
}

/// @nodoc
class _$PrinterJobCopyWithImpl<$Res, $Val extends PrinterJob>
    implements $PrinterJobCopyWith<$Res> {
  _$PrinterJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? status = null,
    Object? document = null,
    Object? user = null,
    Object? printer = null,
    Object? pagesPrinted = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PrinterJobStatus,
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      printer: null == printer
          ? _value.printer
          : printer // ignore: cast_nullable_to_non_nullable
              as String,
      pagesPrinted: null == pagesPrinted
          ? _value.pagesPrinted
          : pagesPrinted // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrinterJobImplCopyWith<$Res>
    implements $PrinterJobCopyWith<$Res> {
  factory _$$PrinterJobImplCopyWith(
          _$PrinterJobImpl value, $Res Function(_$PrinterJobImpl) then) =
      __$$PrinterJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "JobId") int jobId,
      PrinterJobStatus status,
      @JsonKey(name: "Document") String document,
      @JsonKey(name: "User") String user,
      @JsonKey(name: "Printer") String printer,
      @JsonKey(name: "PagesPrinted") int pagesPrinted,
      @JsonKey(name: "TotalPages") int totalPages});
}

/// @nodoc
class __$$PrinterJobImplCopyWithImpl<$Res>
    extends _$PrinterJobCopyWithImpl<$Res, _$PrinterJobImpl>
    implements _$$PrinterJobImplCopyWith<$Res> {
  __$$PrinterJobImplCopyWithImpl(
      _$PrinterJobImpl _value, $Res Function(_$PrinterJobImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
    Object? status = null,
    Object? document = null,
    Object? user = null,
    Object? printer = null,
    Object? pagesPrinted = null,
    Object? totalPages = null,
  }) {
    return _then(_$PrinterJobImpl(
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PrinterJobStatus,
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      printer: null == printer
          ? _value.printer
          : printer // ignore: cast_nullable_to_non_nullable
              as String,
      pagesPrinted: null == pagesPrinted
          ? _value.pagesPrinted
          : pagesPrinted // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PrinterJobImpl implements _PrinterJob {
  const _$PrinterJobImpl(
      {@JsonKey(name: "JobId") this.jobId = -1,
      this.status = PrinterJobStatus.unknown,
      @JsonKey(name: "Document") this.document = "",
      @JsonKey(name: "User") this.user = "",
      @JsonKey(name: "Printer") this.printer = "",
      @JsonKey(name: "PagesPrinted") this.pagesPrinted = -1,
      @JsonKey(name: "TotalPages") this.totalPages = -1});

  @override
  @JsonKey(name: "JobId")
  final int jobId;
  @override
  @JsonKey()
  final PrinterJobStatus status;
  @override
  @JsonKey(name: "Document")
  final String document;
  @override
  @JsonKey(name: "User")
  final String user;
  @override
  @JsonKey(name: "Printer")
  final String printer;
  @override
  @JsonKey(name: "PagesPrinted")
  final int pagesPrinted;
  @override
  @JsonKey(name: "TotalPages")
  final int totalPages;

  @override
  String toString() {
    return 'PrinterJob(jobId: $jobId, status: $status, document: $document, user: $user, printer: $printer, pagesPrinted: $pagesPrinted, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterJobImpl &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.document, document) ||
                other.document == document) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.printer, printer) || other.printer == printer) &&
            (identical(other.pagesPrinted, pagesPrinted) ||
                other.pagesPrinted == pagesPrinted) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, jobId, status, document, user,
      printer, pagesPrinted, totalPages);

  /// Create a copy of PrinterJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterJobImplCopyWith<_$PrinterJobImpl> get copyWith =>
      __$$PrinterJobImplCopyWithImpl<_$PrinterJobImpl>(this, _$identity);
}

abstract class _PrinterJob implements PrinterJob {
  const factory _PrinterJob(
      {@JsonKey(name: "JobId") final int jobId,
      final PrinterJobStatus status,
      @JsonKey(name: "Document") final String document,
      @JsonKey(name: "User") final String user,
      @JsonKey(name: "Printer") final String printer,
      @JsonKey(name: "PagesPrinted") final int pagesPrinted,
      @JsonKey(name: "TotalPages") final int totalPages}) = _$PrinterJobImpl;

  @override
  @JsonKey(name: "JobId")
  int get jobId;
  @override
  PrinterJobStatus get status;
  @override
  @JsonKey(name: "Document")
  String get document;
  @override
  @JsonKey(name: "User")
  String get user;
  @override
  @JsonKey(name: "Printer")
  String get printer;
  @override
  @JsonKey(name: "PagesPrinted")
  int get pagesPrinted;
  @override
  @JsonKey(name: "TotalPages")
  int get totalPages;

  /// Create a copy of PrinterJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterJobImplCopyWith<_$PrinterJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
