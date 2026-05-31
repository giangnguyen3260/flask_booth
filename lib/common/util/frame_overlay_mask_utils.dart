import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@Singleton()
class FrameOverlayMaskUtils {
  final Map<String, String> _cache = {};

  Future<String> resolveMaskedOverlayPath(String sourcePath) async {
    if (sourcePath.isEmpty) {
      return sourcePath;
    }

    final cacheDir = '${Directory.systemTemp.path}/ptb_frame_masks';
    final cachePath = '$cacheDir/masked_${sourcePath.hashCode}.png';

    final cached = _cache[sourcePath];
    if (cached != null && await File(cached).exists()) {
      return cached;
    }
    if (await File(cachePath).exists()) {
      _cache[sourcePath] = cachePath;
      return cachePath;
    }

    final bytes = await _readBytes(sourcePath);
    await Directory(cacheDir).create(recursive: true);
    final maskedPath = await compute(
      _createMaskedOverlayPath,
      _MaskOverlayPayload(bytes: bytes, cachePath: cachePath),
    );
    if (maskedPath == null) {
      return sourcePath;
    }
    _cache[sourcePath] = maskedPath;
    return maskedPath;
  }

  Future<Uint8List> _readBytes(String sourcePath) async {
    if (sourcePath.startsWith('assets/')) {
      final data = await rootBundle.load(sourcePath);
      return data.buffer.asUint8List();
    }
    return File(sourcePath).readAsBytes();
  }
}

class _MaskOverlayPayload {
  const _MaskOverlayPayload({
    required this.bytes,
    required this.cachePath,
  });

  final Uint8List bytes;
  final String cachePath;
}

Future<String?> _createMaskedOverlayPath(_MaskOverlayPayload payload) async {
  final decoded = img.decodeImage(payload.bytes);
  if (decoded == null) {
    return null;
  }

  final masked = img.Image.from(decoded);
  for (final pixel in masked) {
    final r = pixel.r.toInt();
    final g = pixel.g.toInt();
    final b = pixel.b.toInt();
    if (r >= 245 && g >= 245 && b >= 245) {
      pixel.a = 0;
    }
  }

  await File(payload.cachePath).writeAsBytes(
    img.encodePng(masked, level: 1),
    flush: true,
  );
  return payload.cachePath;
}
