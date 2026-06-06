import 'dart:typed_data';

import 'package:edsdk/edsdk.dart';
import 'package:edsdk/models/camera_model.dart';
import 'package:edsdk/models/xfile.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/log/log_mixin.dart';

@Singleton(order: -1)
class CameraUtils with LogMixin {
  final Edsdk _edsdk = Edsdk();

  Future<bool> initSdk() async {
    try {
      return await _edsdk.initSdk();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> terminateSdk() async {
    try {
      return await _edsdk.terminateSdk();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<List<CameraModel>> getCameraList() async {
    try {
      return await _edsdk.getCameraList();
    } on MissingPluginException catch (error) {
      logE(error);
      return [];
    }
  }

  Future<int> initCamera(int index) async {
    try {
      return await _edsdk.initCamera(index);
    } on MissingPluginException catch (error) {
      logE(error);
      return -1;
    }
  }

  Future<bool> startPreview() async {
    try {
      return await _edsdk.startPreview();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> stopPreview() async {
    try {
      return await _edsdk.stopPreview();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<String> downloadEvf({String? fileName}) async {
    try {
      return await _edsdk.downloadEvf(fileName: fileName);
    } on MissingPluginException catch (error) {
      logE(error);
      return "";
    }
  }

  Future<Uint8List> downloadEvfBytes() async {
    try {
      return await _edsdk.downloadEvfBytes();
    } on MissingPluginException catch (error) {
      logE(error);
      return Uint8List(0);
    }
  }

  Future<bool> downloadEvfTexture() async {
    try {
      return await _edsdk.downloadEvfTexture();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> startRecord() async {
    try {
      return await _edsdk.startRecord();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> stopRecord() async {
    try {
      return await _edsdk.stopRecord();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> shoot() async {
    try {
      return await _edsdk.shoot();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> clearMem() async {
    try {
      return await _edsdk.clearMem();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> openSession() async {
    try {
      return await _edsdk.openSession();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> closeSession() async {
    try {
      return await _edsdk.closeSession();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<List<XFile>> downloadData() async {
    try {
      return await _edsdk.downloadData();
    } on MissingPluginException catch (error) {
      logE(error);
      return [];
    }
  }

  Future<bool> saveToHost() async {
    try {
      return await _edsdk.saveToHost();
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  Future<bool> setAspectRatio(int aspectRatio) async {
    try {
      return await _edsdk.setAspectRatio(aspectRatio);
    } on MissingPluginException catch (error) {
      logE(error);
      return false;
    }
  }

  void setObjectHandler({Future<dynamic> Function(MethodCall)? handler}) {
    _edsdk.setObjectHandler(handler: handler);
  }

  Future<void> downloadVideo() async {
    try {
      await _edsdk.downloadVideo();
    } on MissingPluginException catch (error) {
      logE(error);
    }
  }
}
