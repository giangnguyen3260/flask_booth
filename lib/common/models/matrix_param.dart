import 'package:freezed_annotation/freezed_annotation.dart';

part 'matrix_param.freezed.dart';

@freezed
class MatrixParam with _$MatrixParam {
  const factory MatrixParam({
    @Default(1.0) double scale,
    @Default(0.0) double panX,
    @Default(0.0) double panY,
  }) = _MatrixParam;
}
