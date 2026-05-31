import 'package:flutter/material.dart';

enum EAspectRatio {
  oneOne(1 / 1),
  sixteenNine(16 / 9),
  threeTwo(3 / 2),
  fourThree(4 / 3);

  final double aspectRatio;

  const EAspectRatio(this.aspectRatio);
}

extension EAspectRatioExtentions on EAspectRatio {
  Widget coverWidget({bool isVertical = false}) {
    var blackBar = Expanded(
      child: Container(
        color: Colors.black,
      ),
    );
    switch (this) {
      case EAspectRatio.sixteenNine:
        if (isVertical) {
          return Row(
            children: [
              blackBar,
              AspectRatio(
                aspectRatio: 1 / aspectRatio,
                child: Container(),
              ),
              blackBar,
            ],
          );
        }
        return Column(
          children: [
            blackBar,
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(),
            ),
            blackBar,
          ],
        );
      case EAspectRatio.oneOne:
      case EAspectRatio.threeTwo:
      case EAspectRatio.fourThree:
        return Row(
          children: [
            blackBar,
            AspectRatio(
              aspectRatio: isVertical ? 1 / aspectRatio : aspectRatio,
              child: Container(),
            ),
            blackBar,
          ],
        );
    }
  }

  int getSDKCode() {
    return switch (this) {
      EAspectRatio.oneOne => 1,
      EAspectRatio.sixteenNine => 7,
      EAspectRatio.threeTwo => 0,
      EAspectRatio.fourThree => 2,
    };
  }
}
