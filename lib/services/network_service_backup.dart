import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkDevice {
  final String ip;
  final String mac;
  final String name;
  bool blocked;

  NetworkDevice({
    required this.ip,
    required this.mac,
    required this.name,
    this.blocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'mac': mac,
      'name': name,
      'blocked': blocked,
    };
  }

  factory NetworkDevice.fromMap(Map<String, dynamic> map) {
    return NetworkDevice(
      ip: map['ip'],
      mac: map['mac'],
      name: map['name'],
      blocked: map['blocked'] ?? false,
    );
  }
}

class NetworkService with ChangeNotifier {
  final NetworkInfo _networkInfo = NetworkInfo();
  List<NetworkDevice> _devices = [];
  Timer? _scanTimer;

  List<NetworkDevice> get devices => _devices;

  NetworkService() {
    _loadDevices();
    _startAutoScan();
  }

  Future<void> _loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final devicesString = prefs.getString('network_devices');
    if (devicesString != null) {
      final List<dynamic> decoded = json.decode(devicesString);
      _devices = decoded.map((e) => NetworkDevice.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_devices.map((e) => e.toMap()).toList());
    await prefs.setString('network_devices', encoded);
  }

  void _startAutoScan() {
    _scanTimer = Timer.periodic(const Duration(seconds: 30), (_) => scanNetwork());
  }

  Future<void> scanNetwork() async {
    try {
      String? wifiName = await _networkInfo.getWifiName();
      String? wifiIP = await _networkInfo.getWifiIP();
      String? gatewayIP = await _networkInfo.getWifiGatewayIP();

      if (wifiIP != null) {
        final device = NetworkDevice(
          ip: wifiIP,
          mac: '00:00:00:00:00:00', // Pode ser substituído se detectar MAC real
          name: wifiName ?? 'Dispositivo Local',
        );

        // Atualiza dispositivos existentes ou adiciona novo
        final index = _devices.indexWhere((d) => d.ip == device.ip);
        if (index >= 0) {
          _devices[index] = device;
        } else {
          _devices.add(device);
        }
        await _saveDevices();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao obter dados reais da rede: $e');
    }
  }

  void toggleBlock(NetworkDevice device) {
    device.blocked = !device.blocked;
    _saveDevices();
    notifyListeners();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }
}
