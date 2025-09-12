// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 💾 StorageService - Persistência local       ┃
// ┃ 🔧 Salva e carrega dispositivos da memória   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_model.dart';

class StorageService {
  static const _keyDevices = 'stored_devices';

  // 📤 Salva lista de dispositivos
  Future<void> saveDevices(List<DeviceModel> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = devices.map((d) => d.toJson()).toList();
    await prefs.setString(_keyDevices, jsonEncode(jsonList));
  }

  // 📥 Carrega lista de dispositivos
  Future<List<DeviceModel>> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyDevices);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((json) => DeviceModel.fromJson(json)).toList();
  }

  // 🧹 Limpa dispositivos salvos
  Future<void> clearDevices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDevices);
  }
}
