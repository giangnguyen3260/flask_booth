import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:project_l/remote/models/app_data.dart';

@Singleton()
class BackgroundMaskUtils {
  final Map<String, String> _cache = {};

  Future<String> resolveMaskedBackgroundPath(
    String sourcePath,
    List<BackgroundMaskArea> zones,
  ) async {
    if (sourcePath.isEmpty || zones.isEmpty) {
      return sourcePath;
    }

    final cacheKey = '$sourcePath::${jsonEncode(zones.map((e) => e.toJson()).toList())}';
    final cached = _cache[cacheKey];
    if (cached != null && await File(cached).exists()) {
      return cached;
    }

    final bytes = await _readBytes(sourcePath);
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return sourcePath;
    }

    final canvas = img.Image.from(decoded);
    for (final zone in zones) {
      final x = zone.x.round();
      final y = zone.y.round();
      final width = zone.width.round();
      final height = zone.height.round();
      if (x < 0 || y < 0 || width <= 0 || height <= 0) {
        continue;
      }
      if (zone.isTransparent) {
        img.fillRect(
          canvas,
          x1: x,
          y1: y,
          x2: x + width,
          y2: y + height,
          color: img.ColorRgba8(0, 0, 0, 0),
        );
        continue;
      }
      if (zone.isWhite) {
        img.fillRect(
          canvas,
          x1: x,
          y1: y,
          x2: x + width,
          y2: y + height,
          color: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF),
        );
      }
    }

    final cacheDir = '${Directory.systemTemp.path}/ptb_background_masks';
    final cachePath = '$cacheDir/masked_${cacheKey.hashCode}.png';
    await Directory(cacheDir).create(recursive: true);
    await File(cachePath).writeAsBytes(img.encodePng(canvas), flush: true);
    _cache[cacheKey] = cachePath;
    return cachePath;
  }

  Future<Uint8List> _readBytes(String sourcePath) async {
    if (sourcePath.startsWith('assets/')) {
      final data = await rootBundle.load(sourcePath);
      return data.buffer.asUint8List();
    }
    return File(sourcePath).readAsBytes();
  }
}
