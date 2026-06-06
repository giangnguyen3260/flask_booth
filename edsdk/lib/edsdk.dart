import 'dart:typed_data';

import 'package:edsdk/models/camera_model.dart';
import 'package:edsdk/models/xfile.dart';
import 'package:flutter/services.dart';

import 'edsdk_platform_interface.dart';

class Edsdk {
  Future<bool> initSdk() async {
    return await EdsdkPlatform.instance.initSdk();
  }

  Future<bool> terminateSdk() async {
    return await EdsdkPlatform.instance.terminateSdk();
  }

  Future<List<CameraModel>> getCameraList() async {
    return await EdsdkPlatform.instance.getCameraList();
  }

  Future<int> initCamera(int index) async {
    return await EdsdkPlatform.instance.initCamera(index);
  }

  Future<bool> startPreview() async {
    return await EdsdkPlatform.instance.startPreview();
  }

  Future<bool> stopPreview() async {
    return await EdsdkPlatform.instance.stopPreview();
  }

  Future<String> downloadEvf({String? fileName}) async {
    return await EdsdkPlatform.instance.downloadEvf(fileName: fileName);
  }

  Future<Uint8List> downloadEvfBytes() async {
    return await EdsdkPlatform.instance.downloadEvfBytes();
  }

  Future<bool> downloadEvfTexture() async {
    return await EdsdkPlatform.instance.downloadEvfTexture();
  }

  Future<bool> startRecord() async {
    return await EdsdkPlatform.instance.startRecord();
  }

  Future<bool> stopRecord() async {
    return await EdsdkPlatform.instance.stopRecord();
  }

  Future<bool> shoot() async {
    return await EdsdkPlatform.instance.shoot();
  }

  Future<bool> clearMem() async {
    return await EdsdkPlatform.instance.clearMem();
  }

  Future<bool> openSession() async {
    return await EdsdkPlatform.instance.openSession();
  }

  Future<bool> closeSession() async {
    return await EdsdkPlatform.instance.closeSession();
  }

  void setObjectHandler({Future<dynamic> Function(MethodCall)? handler}) {
    EdsdkPlatform.instance.setObjectHandler(handler: handler);
  }

  Future<List<XFile>> downloadData() async {
    return await EdsdkPlatform.instance.downloadData();
  }

  Future<bool> saveToHost() async {
    return await EdsdkPlatform.instance.saveToHost();
  }

  Future<bool> setAspectRatio(int aspectRatio) async {
    return await EdsdkPlatform.instance.setAspectRatio(aspectRatio);
  }

  Future<void> downloadVideo() async {
    return await EdsdkPlatform.instance.downloadVideo();
  }
}
