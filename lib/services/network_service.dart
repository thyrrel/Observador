import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;

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

  Map<String, dynamic> toMap() => {
        'ip': ip,
        'mac': mac,
        'name': name,
        'blocked': blocked,
      };

  factory NetworkDevice.fromMap(Map<String, dynamic> map) => NetworkDevice(
        ip: map['ip'],
        mac: map['mac'],
        name: map['name'],
        blocked: map['blocked'] ?? false,
      );
}

class NetworkService with ChangeNotifier {
  final NetworkInfo _networkInfo = NetworkInfo();
  List<NetworkDevice> _devices = [];

  List<NetworkDevice> get devices => _devices;

  NetworkService() {
    _loadDevices();
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

  Future<Map<String, dynamic>> getNetworkStatus() async {
    final wifiName = await _networkInfo.getWifiName();
    final wifiIP = await _networkInfo.getWifiIP();
    final gateway = await _networkInfo.getWifiGatewayIP();

    return {
      'status': 'conectado',
      'wifiName': wifiName ?? 'Desconhecido',
      'ip': wifiIP ?? '0.0.0.0',
      'gateway': gateway ?? '0.0.0.0',
    };
  }

  void toggleBlock(NetworkDevice device) {
    device.blocked = !device.blocked;
    _saveDevices();
    notifyListeners();
  }
}
