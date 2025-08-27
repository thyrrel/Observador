// lib/services/network_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
      mac: map['mac'] ?? 'unknown',
      name: map['name'] ?? map['ip'],
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
    _scanTimer = Timer.periodic(const Duration(seconds: 60), (_) => scanNetwork());
  }

  Future<String?> getWifiName() async {
    return await _networkInfo.getWifiName();
  }

  Future<String?> getWifiIP() async {
    return await _networkInfo.getWifiIP();
  }

  Future<String?> getGatewayIP() async {
    return await _networkInfo.getWifiGatewayIP();
  }

  Future<void> scanNetwork() async {
    final localIp = await getWifiIP();
    if (localIp == null) return;

    final subnet = localIp.substring(0, localIp.lastIndexOf('.'));
    List<NetworkDevice> scannedDevices = [];

    for (int i = 1; i <= 254; i++) {
      final ip = '$subnet.$i';
      try {
        final result = await InternetAddress(ip).ping(timeout: const Duration(milliseconds: 300));
        if (result) {
          final existing = _devices.firstWhere(
            (d) => d.ip == ip,
            orElse: () => NetworkDevice(ip: ip, mac: 'unknown', name: ip),
          );
          scannedDevices.add(NetworkDevice(
            ip: ip,
            mac: existing.mac,
            name: existing.name,
            blocked: existing.blocked,
          ));
        }
      } catch (_) {}
    }

    _devices = scannedDevices;
    await _saveDevices();
    notifyListeners();
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

// Extension para ping simples
extension on InternetAddress {
  Future<bool> ping({Duration timeout = const Duration(seconds: 1)}) async {
    try {
      final socket = await Socket.connect(this, 80, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }
}
