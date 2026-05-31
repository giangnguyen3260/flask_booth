import 'dart:convert';

import 'package:edsdk/models/camera_model.dart';
import 'package:edsdk/models/xfile.dart';
import 'package:flutter/services.dart';

import 'edsdk_platform_interface.dart';

/// An implementation of [EdsdkPlatform] that uses method channels.
class MethodChannelEdsdk extends EdsdkPlatform {
  final methodChannel = const MethodChannel('edsdk');

  final callbackChannel = const MethodChannel('callback');

  @override
  Future<bool> initSdk() async {
    return await methodChannel.invokeMethod<bool>("init_sdk") ?? false;
  }

  @override
  Future<bool> terminateSdk() async {
    return await methodChannel.invokeMethod<bool>("terminate_sdk") ?? false;
  }

  @override
  Future<List<CameraModel>> getCameraList() async {
    final String? result =
        await methodChannel.invokeMethod<String?>("list_camera");
    List<CameraModel> cameraList = [];
    if (result != null) {
      var lMap = jsonDecode(result) as List<dynamic>;
      for (int i = 0; i < lMap.length; i++) {
        var map = lMap[i] as Map<String, dynamic>;
        cameraList.add(CameraModel.fromJson(map));
      }
    }
    return cameraList;
  }

  @override
  Future<int> initCamera(int index) async {
    return await methodChannel.invokeMethod<int>("init_camera", {
          "index": index,
        }) ??
        -1;
  }

  @override
  Future<bool> startPreview() async {
    return await methodChannel.invokeMethod<bool>("start_preview") ?? false;
  }

  @override
  Future<bool> stopPreview() async {
    return await methodChannel.invokeMethod<bool>("stop_preview") ?? false;
  }

  @override
  Future<String> downloadEvf() async {
    return await methodChannel.invokeMethod("download_evf");
  }

  @override
  Future<bool> shoot() async {
    return await methodChannel.invokeMethod<bool>("shoot") ?? false;
  }

  @override
  Future<bool> clearMem() async {
    return await methodChannel.invokeMethod<bool>("clear_mem") ?? false;
  }

  @override
  Future<bool> openSession() async {
    return await methodChannel.invokeMethod<bool>("open_session") ?? false;
  }

  @override
  Future<bool> closeSession() async {
    return await methodChannel.invokeMethod<bool>("close_session") ?? false;
  }

  @override
  void setObjectHandler({Future Function(MethodCall call)? handler}) async {
    callbackChannel.setMethodCallHandler(handler);
  }

  @override
  Future<List<XFile>> downloadData() async {
    final String? result =
        await methodChannel.invokeMethod<String?>("download_data");
    List<XFile> data = [];
    if (result != null) {
      var lMap = jsonDecode(result.replaceAll("\\", "/")) as List<dynamic>;
      print(lMap);
      for (int i = 0; i < lMap.length; i++) {
        var map = lMap[i] as Map<String, dynamic>;
        data.add(XFile.fromJson(map));
      }
    }
    return data;
  }

  @override
  Future<bool> saveToHost() async {
    return await methodChannel.invokeMethod<bool>("save_to_host") ?? false;
  }

  @override
  Future<bool> setAspectRatio(int aspectRatio) async {
    return await methodChannel.invokeMethod<bool>("set_aspect_ratio", {
          "aspect_ratio": aspectRatio,
        }) ??
        false;
  }

  @override
  Future<void> downloadVideo() async{
     await methodChannel.invokeMethod("download_video") ??
        false;
  }
}
