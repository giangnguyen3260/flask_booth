class XFile {
  final String imagePath;
  final String videoPath;

  XFile(this.imagePath, this.videoPath);

  static XFile fromJson(Map<String, dynamic> json) {
    return XFile(
      json["imagePath"] as String,
      json["videoPath"] as String,
    );
  }

  @override
  String toString() {
    return "XFile(imagePath: $imagePath,videoPath: $videoPath)";
  }
}
