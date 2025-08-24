// lib/services/network_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../models/device_model.dart';

class NetworkService {
  final StreamController<List<DeviceModel>> _devicesController =
      StreamController<List<DeviceModel>>.broadcast();

  List<DeviceModel> _devices = [];

  final NetworkInfo _networkInfo = NetworkInfo();

  NetworkService() {
    scanNetwork(); // inicia scan automaticamente
  }

  Stream<List<DeviceModel>> get devicesStream => _devicesController.stream;

  void _updateDevicesStream() {
    _devicesController.add(List.unmodifiable(_devices));
  }

  /// Escaneia a rede local e detecta dispositivos ativos
  Future<void> scanNetwork() async {
    _devices = [];
    String? ip = await _networkInfo.getWifiIP();
    String? subnet = await _networkInfo.getWifiSubmask();

    if (ip == null || subnet == null) return;

    // Obtém o prefixo da sub-rede (ex: 192.168.0)
    List<String> parts = ip.split('.');
    String prefix = '${parts[0]}.${parts[1]}.${parts[2]}';

    for (int i = 1; i <= 254; i++) {
      String testIp = '$prefix.$i';
      bool reachable = await _ping(testIp);
      if (reachable && testIp != ip) {
        // Cria DeviceModel real
        _devices.add(DeviceModel(
          name: 'Dispositivo $i',
          ip: testIp,
          isBlocked: false,
        ));
        _updateDevicesStream();
      }
    }
  }

  /// Verifica se o IP está ativo (ping)
  Future<bool> _ping(String ip) async {
    try {
      final result = await Process.run(
        'ping',
        ['-c', '1', '-W', '1', ip],
        runInShell: true,
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Checa conexão com a internet
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  void dispose() {
    _devicesController.close();
  }
}
