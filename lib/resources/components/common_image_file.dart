import 'dart:io';
import 'package:flutter/material.dart';

enum CustomResizeImagePolicy { exact, fit } // Renamed enum

class CommonImageFile extends StatelessWidget {
  final String path;
  final int scaledWidth;
  final int scaledHeight;
  final double? widgetWidth;
  final double? widgetHeight;
  final BoxFit fit;
  final CustomResizeImagePolicy
      policy; // Changed type to CustomResizeImagePolicy

  const CommonImageFile({
    super.key,
    required this.path,
    this.scaledWidth = 300,
    this.scaledHeight = 200,
    this.widgetWidth,
    this.widgetHeight,
    this.fit = BoxFit.cover,
    this.policy =
        CustomResizeImagePolicy.exact, // Changed to CustomResizeImagePolicy
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Center(child: SizedBox.shrink()),
      );
    }
    final file = File(path);
    if (!file.existsSync()) {
      return SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: const Center(
          child: Icon(Icons.error, color: Colors.red),
        ),
      );
    }

    return Image.file(
      file,
      key: ValueKey(file.path),
      width: widgetWidth,
      height: widgetHeight,
      fit: fit,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: widgetWidth,
          height: widgetHeight,
          child: const Center(
            child: Icon(Icons.error, color: Colors.red),
          ),
        );
      },
    );
  }
}
