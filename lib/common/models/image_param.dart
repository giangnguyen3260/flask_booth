import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_l/common/models/effect.dart';
import 'package:project_l/common/models/matrix_param.dart';
import 'package:project_l/remote/models/app_data.dart';

part 'image_param.freezed.dart';

@freezed
class ImageParam with _$ImageParam {
  const factory ImageParam({
    @Default("") String session,
    @Default([]) List<String> images,
    @Default([]) List<String> videos,
    @Default(false) bool isFlipped,
    @Default(FramesInfo()) FramesInfo selectedFrame,
    @Default(Background()) Background selectedBackground,
    @Default([]) List<MatrixParam> pansAndScales,
    ColorFilterGenerator? colorFilter,
    Effect? effect,
    @Default(0) int printQuantity,
    String? couponCode,
  }) = _ImageParam;
}
