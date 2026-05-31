import 'dart:convert';
import 'dart:typed_data';

class StringUtils {
  static List<String> extractNumbers(String input) {
    // Regular expression to find all numbers in the string
    RegExp regExp = RegExp(r'\d+');
    // Find all matches of the regular expression in the input string
    Iterable<Match> matches = regExp.allMatches(input);
    // Map the matches to their string values and convert the result to a list
    List<String> numbers = matches.map((match) => match.group(0)!).toList();
    return numbers;
  }

  static String camelCaseToNormal(String input) {
    // Insert a space before each uppercase letter and convert the entire string to lowercase
    String spaced =
        input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match match) {
      return "${match.group(1)} ${match.group(2)}";
    }).toLowerCase();

    // Capitalize the first letter of the resulting string
    String capitalized = spaced[0].toUpperCase() + spaced.substring(1);

    return capitalized;
  }

  static String bytesToHexWithSpaces(Uint8List bytes) {
    final buffer = StringBuffer();
    for (int i = 0; i < bytes.length; i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0').toUpperCase());
      if (i < bytes.length - 1) {
        buffer.write(' '); // Add space between bytes
      }
    }
    return buffer.toString();
  }

  static String addDashesEvery4Chars(String input) {
    StringBuffer sb = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) {
        sb.write('-');
      }
      sb.write(input[i]);
    }

    return sb.toString();
  }

  /// Chuyển đổi một chuỗi dạng JSON thành List<List<double>>
  static List<List<double>> parseToListOfListDouble(String jsonString) {
    if (jsonString.trim().isEmpty) {
      return [];
    }

    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! List<dynamic>) {
      return [];
    }

    final List<List<double>> rects = [];
    for (final item in decoded) {
      if (item is List<dynamic> && item.length >= 4) {
        final values = item
            .take(4)
            .map((value) => (value as num).toDouble())
            .toList();
        if (values.length == 4) {
          rects.add(values);
        }
        continue;
      }

      if (item is Map<String, dynamic>) {
        final x = (item['x'] ?? item['left'] ?? item['minX']) as num?;
        final y = (item['y'] ?? item['top'] ?? item['minY']) as num?;
        final width =
            (item['width'] ?? item['w'] ?? item['maxX'] ?? item['right']) as num?;
        final height =
            (item['height'] ?? item['h'] ?? item['maxY'] ?? item['bottom']) as num?;
        if (x != null && y != null && width != null && height != null) {
          rects.add([x.toDouble(), y.toDouble(), width.toDouble(), height.toDouble()]);
        }
      }
    }

    return rects.where((rect) => rect.length == 4).toList();
  }
}
