import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/log/log_mixin.dart';

@singleton
class CameraPowerUtil with LogMixin {
  late final SerialPort _serialPort;
  bool _status = false;
  late final Map<String, dynamic> cameraPowerConfig;
  bool _isConnected = false;

  set serialPort(SerialPort value) {
    _serialPort = value;
  }

  bool connect() {
    try {
      var ports = SerialPort.availablePorts;
      if (ports.isEmpty) {
        _isConnected = false;
        return false;
      }
      logD("Available ports: $ports");
      final portName = (cameraPowerConfig["port"] ?? '').toString().trim();
      if (portName.isEmpty) {
        logE("Camera power port is empty");
        _isConnected = false;
        return false;
      }

      final matchedPorts = ports.where((e) => e == portName).toList();
      if (matchedPorts.isEmpty) {
        logE("Can't find camera power port: $portName");
        _isConnected = false;
        return false;
      }

      _serialPort = SerialPort(matchedPorts.first);

      _serialPort.openReadWrite();
      _isConnected = true;
      return true;
    } catch (e) {
      logE(e);
      _isConnected = false;
      return false;
    }
  }

  void _sendCommand(String command) {
    if (!_isConnected) {
      return;
    }
    Uint8List commandBytes = Uint8List.fromList(utf8.encode(command));
    _serialPort.write(commandBytes);
  }

  void turnOnCamera() {
    if (!_status) {
      _sendCommand("ON\n");
      _status = true;
    }
  }

  void turnOffCamera() {
    _sendCommand("OFF\n");
    _status = false;
  }
}
