import 'dart:io';
import 'dart:typed_data';
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

  CommonImageFile({
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

  final Uint8List _kTransparentImage = Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82
  ]);

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

    return FadeInImage(
      placeholder: MemoryImage(_kTransparentImage),
      image: ResizeImage(
        FileImage(file),
        width: scaledWidth,
        height: scaledHeight,
        allowUpscaling: true,
        policy: policy == CustomResizeImagePolicy.exact
            ? ResizeImagePolicy.exact
            : ResizeImagePolicy.fit,
      ),
      width: widgetWidth,
      height: widgetHeight,
      fit: fit,
      imageErrorBuilder: (context, error, stackTrace) {
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
