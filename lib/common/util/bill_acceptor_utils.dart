import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/constants/enum/bill_acceptor_command.dart';
import 'package:project_l/common/constants/enum/bill_acceptor_response.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/util/string_utils.dart';

@Singleton()
class BillAcceptorUtils with LogMixin {
  late final SerialPort _serialPort;
  late SerialPortReader _serialPortReader;
  late final Map<String, dynamic> _billAcceptorConfig;
  bool status = false;
  bool _isConnected = false;
  final StreamController<BillAcceptorResponseEnum> _stream =
      StreamController.broadcast();
  StreamSubscription<BillAcceptorResponseEnum>? _subscription;

  set billAcceptorConfig(Map<String, dynamic> value) {
    _billAcceptorConfig = value;
  }

  bool connect() {
    try {
      var ports = SerialPort.availablePorts;
      if (ports.isEmpty) {
        logE("Can't find port");
        status = false;
        _isConnected = false;
        return false;
      }
      logD("Available ports: $ports");
      final portName = (_billAcceptorConfig["port"] ?? '').toString().trim();
      if (portName.isEmpty) {
        logE("Bill acceptor port is empty");
        status = false;
        _isConnected = false;
        return false;
      }

      final matchedPorts = ports.where((e) => e == portName).toList();
      if (matchedPorts.isEmpty) {
        logE("Can't find bill acceptor port: $portName");
        status = false;
        _isConnected = false;
        return false;
      }

      _serialPort = SerialPort(matchedPorts.first);
      _openReadWrite();
      status = true;
      _isConnected = true;
      return true;
    } catch (e) {
      logE(e);
      status = false;
      _isConnected = false;

      return false;
    }
  }

  bool _openReadWrite() {
    try {
      var result = _serialPort.openReadWrite();
      if (result) {
        logD("${_serialPort.name ?? ""} connects successfully");
        final config = SerialPortConfig()
          ..baudRate = 9600
          ..stopBits = 1
          ..bits = 8
          ..parity = SerialPortParity.none
          ..setFlowControl(SerialPortFlowControl.none);
        if (_readBoolConfig("rts")) {
          config.rts = SerialPortRts.on;
        }
        if (_readBoolConfig("dtr")) {
          config.dtr = SerialPortDtr.on;
        }
        _serialPort.config = config;
        _serialPortReader = SerialPortReader(_serialPort, timeout: 10);

        _serialPortReader.stream.listen((Uint8List value) {
          try {
            var rawData = StringUtils.bytesToHexWithSpaces(value);
            logD("Bill acceptor raw: $rawData");
            final rawResponse = _billAcceptorConfig[rawData.toString()];
            if (rawResponse != null) {
              _emitResponse(rawData, rawResponse);
              return;
            }
            for (final byte in value) {
              final hex = byte.toRadixString(16).padLeft(2, '0').toUpperCase();
              final dataRes = _billAcceptorConfig[hex];
              if (dataRes == null) {
                logE("Unknown bill acceptor response: $hex");
                continue;
              }
              _emitResponse(hex, dataRes);
            }
          } catch (e) {
            logE(e);
          }
        }, onError: (error) {
          logE(error);
        });
      } else {
        logE("Fail to connect ${_serialPort.name ?? ""}");
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  bool _readBoolConfig(String key) {
    final value = _billAcceptorConfig[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == "true" || normalized == "1" || normalized == "yes";
    }
    return false;
  }

  void _emitResponse(String rawData, Object dataRes) {
    final enumData = BillAcceptorResponseEnum.fromValue(dataRes.toString());
    if (enumData == BillAcceptorResponseEnum.unknown) {
      logE("Unknown bill acceptor response mapping: $rawData -> $dataRes");
      return;
    }
    logD("Bill acceptor response: ${enumData.name}");
    _stream.sink.add(enumData);
    if (enumData == BillAcceptorResponseEnum.powerOn) {
      _send(command: BillAcceptorCommand.start);
    }
  }

  bool _send({
    required BillAcceptorCommand command,
  }) {
    try {
      if (!_isConnected) {
        logE('Skipped sending ${command.name}: bill acceptor is disconnected');
        return false;
      }
      var result = _serialPort.write(Uint8List(1)..[0] = command.value);
      if (result > 0) {
        logD('Successfully sent ${command.name}');
      } else {
        logE('Failed to send ${command.name}');
      }
      return result > 0;
    } catch (e) {
      logE(e);
      return false;
    }
  }

  bool disable() {
    return _send(command: BillAcceptorCommand.disableBillAcceptor);
  }

  bool enable() {
    return _send(command: BillAcceptorCommand.enableBillAcceptor);
  }

  bool accept() {
    return _send(command: BillAcceptorCommand.accept);
  }

  bool reject() {
    return _send(command: BillAcceptorCommand.reject);
  }

  void closeSection() {
    try {
      _subscription?.cancel();
      _subscription = null;
    } catch (e) {
      //
    }
  }

  void listen({
    required Function(BillAcceptorResponseEnum data) onData,
    Function()? onError,
  }) {
    if (_subscription != null) {
      _subscription!.cancel().then((_) {
        _subscription = _stream.stream.listen((BillAcceptorResponseEnum data) {
          onData(data);
        }, onError: (er) {
          onError?.call();
        });
      });
    } else {
      _subscription = _stream.stream.listen((BillAcceptorResponseEnum data) {
        onData(data);
      }, onError: (er) {
        onError?.call();
      });
    }
  }
}
