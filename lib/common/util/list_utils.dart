class ListUtils {
  static List<List<double>> sortZShape(List<List<double>> coordinates) {
    if (coordinates.isEmpty) {
      return [];
    }
    // Sắp xếp theo thứ tự y (vị trí dọc), vì các tọa độ đều có giá trị x giống nhau
    coordinates.sort((a, b) => a[1].compareTo(b[1]));

    // Tạo danh sách kết quả theo hình chữ Z
    List<List<double>> result = [];
    // Lấy các điểm ở vị trí thấp nhất
    result.add(coordinates[0]);

    // Duyệt qua các điểm còn lại theo thứ tự hình chữ Z
    for (int i = 1; i < coordinates.length; i++) {
      if (i == 2) {
        // Chuyển hướng sang trái
        result.add(coordinates[2]);
      } else {
        result.add(coordinates[i]);
      }
    }

    return result;
  }
}
