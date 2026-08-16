import 'package:project_l/common/models/effect.dart';

class BeautyEffect {
  const BeautyEffect._();

  static const Effect smoothRose = Effect(
    brightness: 0.08,
    contrast: 0.82,
    saturation: 1.02,
    vibrance: 0.06,
    temperature: -0.04,
    sepia: 0.0,
    grain: -0.08,
  );

  static bool isEnabled(Effect? effect) {
    return (effect?.grain ?? 0) < 0;
  }
}
