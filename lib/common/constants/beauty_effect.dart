import 'package:project_l/common/models/effect.dart';

class BeautyEffect {
  const BeautyEffect._();

  static const Effect smoothRose = Effect(
    brightness: 0.22,
    contrast: 0.94,
    saturation: 1.08,
    vibrance: 0.08,
    temperature: 0.22,
    sepia: 0.0,
    grain: -0.08,
  );

  static bool isEnabled(Effect? effect) {
    return (effect?.grain ?? 0) < 0;
  }
}
