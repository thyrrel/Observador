// lib/services/network_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkService {
  final StreamController<List<String>> _devicesController =
      StreamController<List<String>>.broadcast();

  List<String> _devices = [];

  final NetworkInfo _networkInfo = NetworkInfo();

  NetworkService() {
    scanNetwork(); // inicia o scan automaticamente
  }

  Stream<List<String>> get devicesStream => _devicesController.stream;

  void _updateDevicesStream() {
    _devicesController.add(_devices);
  }

  /// Varre a rede local e identifica dispositivos ativos
  Future<void> scanNetwork() async {
    _devices = [];
    String? ip = await _networkInfo.getWifiIP();
    String? subnet = await _networkInfo.getWifiSubmask();

    if (ip == null || subnet == null) return;

    // Obtém o prefixo da sub-rede (ex: 192.168.0)
    List<String> parts = ip.split('.');
    String prefix = '${parts[0]}.${parts[1]}.${parts[2]}';

    // Escaneia os IPs de 1 a 254
    for (int i = 1; i <= 254; i++) {
      String testIp = '$prefix.$i';
      bool reachable = await _ping(testIp);
      if (reachable && testIp != ip) {
        _devices.add(testIp);
        _updateDevicesStream();
      }
    }
  }

  /// Ping simples para verificar se o IP está ativo
  Future<bool> _ping(String ip) async {
    try {
      final result = await Process.run(
        'ping',
        ['-c', '1', '-W', '1', ip],
        runInShell: true,
      );
      if (result.exitCode == 0) return true;
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Checa se há internet
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
