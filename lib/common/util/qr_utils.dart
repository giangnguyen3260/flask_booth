import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:zxing2/qrcode.dart';

@Injectable()
class QrUtils {
   Future<Uint8List> generateQr({
    required String encodedString,
    required double size, // Chỉ truyền size thay vì width và height
    double padding = 5, // Thêm tham số padding (mặc định là 10)
  }) async {
    var qrcode = Encoder.encode(encodedString, ErrorCorrectionLevel.l);
    var matrix = qrcode.matrix!;

    // Tính toán tỷ lệ scale dựa trên chiều rộng hoặc chiều cao
    double scaleX =
        (size - padding * 2) / matrix.width.toDouble(); // Trừ padding
    double scaleY =
        (size - padding * 2) / matrix.height.toDouble(); // Trừ padding

    // Chọn tỷ lệ nhỏ hơn giữa scaleX và scaleY để giữ tỷ lệ không bị méo
    var scale = (scaleX < scaleY ? scaleX : scaleY).toInt();

    // Kích thước ảnh bao gồm cả padding
    int imageWidth = (matrix.width * scale).toInt() + (padding * 2).toInt();
    int imageHeight = (matrix.height * scale).toInt() + (padding * 2).toInt();

    // Tạo một ảnh với nền trắng
    var image = img.Image(
      width: imageWidth,
      height: imageHeight,
      numChannels: 4,
      backgroundColor: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF), // Nền trắng
    );

    img.fill(
      image,
      color: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF), // Màu trắng
    );

    // Vẽ mã QR lên ảnh (có tính đến padding)
    for (var x = 0; x < matrix.width; x++) {
      for (var y = 0; y < matrix.height; y++) {
        if (matrix.get(x, y) == 1) {
          img.fillRect(
            image,
            x1: (x * scale + padding).toInt(),
            y1: (y * scale + padding).toInt(),
            x2: (x * scale + scale + padding).toInt(),
            y2: (y * scale + scale + padding).toInt(),
            color: img.ColorRgba8(0, 0, 0, 0xFF),
            // Màu đen cho mã QR
            maskChannel: img.Channel.luminance,
          );
        }
      }
    }

    return img.encodePng(image);
  }
}
