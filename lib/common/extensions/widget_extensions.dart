import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget flip({bool isFlip = false}) {
    return Transform.flip(
      flipX: isFlip,
      child: this,
    );
  }
}
