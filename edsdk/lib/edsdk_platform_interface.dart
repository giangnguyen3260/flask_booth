import 'package:edsdk/models/camera_model.dart';
import 'package:edsdk/models/xfile.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'edsdk_method_channel.dart';

abstract class EdsdkPlatform extends PlatformInterface {
  /// Constructs a EdsdkPlatform.
  EdsdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static EdsdkPlatform _instance = MethodChannelEdsdk();

  /// The default instance of [EdsdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelEdsdk].
  static EdsdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EdsdkPlatform] when
  /// they register themselves.
  static set instance(EdsdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> initSdk() {
    throw UnimplementedError('initSdk() has not been implemented.');
  }

  Future<bool> terminateSdk() {
    throw UnimplementedError('terminateSdk() has not been implemented.');
  }

  Future<List<CameraModel>> getCameraList() {
    throw UnimplementedError('getCameraList() has not been implemented.');
  }

  Future<int> initCamera(int index) {
    throw UnimplementedError('initCamera() has not been implemented.');
  }

  Future<bool> startPreview() {
    throw UnimplementedError('startPreview() has not been implemented.');
  }

  Future<bool> stopPreview() {
    throw UnimplementedError('stopPreview() has not been implemented.');
  }

  Future<String> downloadEvf() {
    throw UnimplementedError('downloadEvf() has not been implemented.');
  }

  Future<bool> shoot() {
    throw UnimplementedError('shoot() has not been implemented.');
  }

  Future<bool> clearMem() {
    throw UnimplementedError('clearMem() has not been implemented.');
  }

  Future<bool> openSession() {
    throw UnimplementedError('openSession() has not been implemented.');
  }

  Future<bool> closeSession() {
    throw UnimplementedError('closeSession() has not been implemented.');
  }

  void setObjectHandler({Future<dynamic> Function(MethodCall)? handler}) {
    throw UnimplementedError('setObjectHandler() has not been implemented.');
  }

  Future<List<XFile>> downloadData(){
    throw UnimplementedError('downloadData() has not been implemented.');
  }

  Future<bool> saveToHost(){
    throw UnimplementedError('saveToHost() has not been implemented.');
  }

  Future<bool> setAspectRatio(int aspectRatio){
    throw UnimplementedError('setAspectRatio() has not been implemented.');
  }

  Future<void> downloadVideo(){
    throw UnimplementedError('downloadVideo() has not been implemented.');
  }
}
