// lib/services/bluetooth_service.dart
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothService {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  Stream<List<BluetoothDevice>> get connectedDevices async* {
    var devices = await _flutterBlue.connectedDevices;
    yield devices;
  }

  Stream<List<ScanResult>> scanDevices({Duration timeout = const Duration(seconds: 5)}) {
    _flutterBlue.startScan(timeout: timeout);
    return _flutterBlue.scanResults.map((results) => results);
  }

  void stopScan() => _flutterBlue.stopScan();
}
