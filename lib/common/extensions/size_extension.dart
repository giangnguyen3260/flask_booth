import 'dart:ui';

import 'package:project_l/common/enums/orientation_enum.dart';

extension SizeOrientation on Size {
  OrientationEnum get orientation {
    if (width > height) {
      return OrientationEnum.landscape;
    } else if (height > width) {
      return OrientationEnum.portrait;
    } else {
      return OrientationEnum.square;
    }
  }
}
