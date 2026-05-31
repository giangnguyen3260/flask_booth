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
        _serialPort.config = SerialPortConfig()
          ..baudRate = 9600
          ..stopBits = 1
          ..bits = 8
          ..parity = SerialPortFlowControl.none
          ..setFlowControl(SerialPortFlowControl.none);
        _serialPortReader = SerialPortReader(_serialPort, timeout: 10);

        _serialPortReader.stream.listen((Uint8List value) {
          try {
            var rawData = StringUtils.bytesToHexWithSpaces(value);
            var dataRes = _billAcceptorConfig[rawData.toString()];
            BillAcceptorResponseEnum enumData =
                BillAcceptorResponseEnum.fromValue(dataRes);
            _stream.sink.add(enumData);
          } catch (e) {
            //
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

  bool _send({
    required BillAcceptorCommand command,
  }) {
    try {
      if (!_isConnected) {
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
    return _send(command: BillAcceptorCommand.reset);
  }

  bool enable() {
    return _send(command: BillAcceptorCommand.start);
  }

  bool accept() {
    return _send(command: BillAcceptorCommand.accept);
  }

  bool reject() {
    return _send(command: BillAcceptorCommand.reject);
  }

  void closeSection() {
    try {
      _isConnected = false;
      _subscription?.cancel();
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
