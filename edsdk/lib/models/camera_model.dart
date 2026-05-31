class CameraModel {
  final String szDeviceDescription;
  final int deviceSubType;
  final int reserved;

  CameraModel(this.szDeviceDescription, this.deviceSubType, this.reserved);

  static CameraModel fromJson(Map<String, dynamic> json) {
    return CameraModel(
      json["szDeviceDescription"] as String,
      json["deviceSubType"] as int,
      json["reserved"] as int,
    );
  }

  @override
  String toString() {
    return "CameraModel(szDeviceDescription: $szDeviceDescription,deviceSubType: $deviceSubType,reserved: $reserved})";
  }
}
