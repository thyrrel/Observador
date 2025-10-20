// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 💾 StorageService - Persistência local       ┃
// ┃ 🔧 Salva e carrega dispositivos da memória   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_model.dart';

class StorageService {
  static const _keyDevices = 'stored_devices';

  // 📥 Carrega instância de SharedPreferences (melhora legibilidade)
  Future<SharedPreferences> _getPrefs() => SharedPreferences.getInstance();
  
  // 💡 CORREÇÃO 1: Métodos genéricos de persistência para o LoggerService

  // 📝 Salva dados genéricos (usado pelo LoggerService)
  Future<void> save(String key, String data) async {
    final prefs = await _getPrefs();
    await prefs.setString(key, data);
  }

  // 📖 Lê dados genéricos (usado pelo LoggerService)
  Future<String?> read(String key) async {
    final prefs = await _getPrefs();
    return prefs.getString(key);
  }

  // ❌ Remove dados genéricos (usado pelo LoggerService)
  Future<void> delete(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }

  // 📤 Salva lista de dispositivos
  Future<void> saveDevices(List<DeviceModel> devices) async {
    final prefs = await _getPrefs();
    // A chamada a d.toJson() será resolvida no próximo arquivo!
    final jsonList = devices.map((d) => d.toJson()).toList(); 
    await prefs.setString(_keyDevices, jsonEncode(jsonList));
  }

  // 📥 Carrega lista de dispositivos
  Future<List<DeviceModel>> loadDevices() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_keyDevices);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    // A chamada a DeviceModel.fromJson() será resolvida no próximo arquivo!
    return decoded.map((json) => DeviceModel.fromJson(json)).toList();
  }

  // 🧹 Limpa dispositivos salvos
  Future<void> clearDevices() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyDevices);
  }
}
