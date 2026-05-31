
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:project_l/common/models/effect.dart';
import 'package:project_l/resources/components/common_image_file.dart';

class CommonShaderImage extends StatelessWidget {
  const CommonShaderImage(
      {super.key, required this.effect, required this.imagePath});

  final Effect effect;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, shader, child) {
      return AnimatedSampler(
        (image, size, canvas) {
          shader.setFloatUniforms((uniforms) {
            uniforms
                  ..setFloat(effect.brightness) // uBrightness
                  ..setFloat(effect.contrast) // uContrast
                  ..setFloat(effect.saturation) // uSaturation
                  ..setFloat(
                    effect.vibrance,
                  )
                  ..setFloat(effect.temperature)
                  ..setFloat(effect.sepia)
                  ..setFloat(effect.grain)
                  ..setFloat(size.width) // uScreenSize.x
                  ..setFloat(size.height) // uScreenSize.y
                ; // uHighlights
            // ..setSize(size);
          });

          shader.setImageSampler(0, image);

          canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Paint()..shader = shader,
          );
        },
        child: CommonImageFile(
          path: imagePath,
        ),
      );
    }, assetKey: 'shaders/filters.frag');
  }
}
