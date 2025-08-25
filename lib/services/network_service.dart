// lib/services/network_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    _scanTimer = Timer.periodic(Duration(seconds: 30), (_) => scanNetwork());
  }

  Future<void> scanNetwork() async {
    // Aqui você pode implementar escaneamento real da rede.
    // Exemplo simulado:
    final simulatedDevices = [
      NetworkDevice(ip: '192.168.0.10', mac: 'AA:BB:CC:DD:EE:01', name: 'Laptop'),
      NetworkDevice(ip: '192.168.0.11', mac: 'AA:BB:CC:DD:EE:02', name: 'Smartphone'),
    ];

    // Mantém bloqueios existentes
    for (var dev in simulatedDevices) {
      final existing = _devices.firstWhere(
        (d) => d.mac == dev.mac,
        orElse: () => dev,
      );
      dev.blocked = existing.blocked;
    }

    _devices = simulatedDevices;
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
