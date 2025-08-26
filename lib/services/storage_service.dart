import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_model.dart';

class StorageService {
  Future<void> saveDevices(List<NetworkDevice> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(devices.map((d) => d.toMap()).toList());
    await prefs.setString('network_devices', encoded);
  }

  Future<List<NetworkDevice>> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final devicesString = prefs.getString('network_devices');
    if (devicesString == null) return [];
    final List<dynamic> decoded = json.decode(devicesString);
    return decoded.map((e) => NetworkDevice.fromMap(e)).toList();
  }
}
