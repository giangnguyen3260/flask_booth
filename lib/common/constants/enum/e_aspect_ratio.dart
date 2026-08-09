import 'package:flutter/material.dart';

enum EAspectRatio {
  oneOne('1:1', 1 / 1, 1),
  sixteenNine('16:9', 16 / 9, 7),
  nineSixteen('9:16', 9 / 16, 7),
  threeTwo('3:2', 3 / 2, 0),
  twoThree('2:3', 2 / 3, 0),
  fourThree('4:3', 4 / 3, 2),
  threeFour('3:4', 3 / 4, 2);

  final String value;
  final double aspectRatio;
  final int sdkCode;

  const EAspectRatio(this.value, this.aspectRatio, this.sdkCode);

  static EAspectRatio fromString(String? value) {
    final normalized = value?.trim();
    return EAspectRatio.values.firstWhere(
      (item) => item.value == normalized,
      orElse: () => EAspectRatio.sixteenNine,
    );
  }
}

extension EAspectRatioExtentions on EAspectRatio {
  Widget coverWidget({bool? isVertical}) {
    final effectiveAspectRatio = isVertical == null
        ? aspectRatio
        : isVertical
            ? (aspectRatio > 1 ? 1 / aspectRatio : aspectRatio)
            : (aspectRatio < 1 ? 1 / aspectRatio : aspectRatio);
    var blackBar = Expanded(
      child: Container(
        color: Colors.black,
      ),
    );
    if (effectiveAspectRatio > 1) {
      return Column(
        children: [
          blackBar,
          AspectRatio(
            aspectRatio: effectiveAspectRatio,
            child: Container(),
          ),
          blackBar,
        ],
      );
    }
    return Row(
      children: [
        blackBar,
        AspectRatio(
          aspectRatio: effectiveAspectRatio,
          child: Container(),
        ),
        blackBar,
      ],
    );
  }

  int getSDKCode() {
    return sdkCode;
  }
}
