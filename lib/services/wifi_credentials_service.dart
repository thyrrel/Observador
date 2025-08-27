import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WifiCredentialsService {
  final _storage = const FlutterSecureStorage();

  // Salva a senha de um SSID
  Future<void> saveCredentials(String ssid, String password) async {
    await _storage.write(key: ssid, value: password);
  }

  // Recupera a senha de um SSID
  Future<String?> getPassword(String ssid) async {
    return await _storage.read(key: ssid);
  }

  // Remove as credenciais de um SSID
  Future<void> deleteCredentials(String ssid) async {
    await _storage.delete(key: ssid);
  }

  // Lista todos os SSIDs salvos
  Future<Map<String, String>> getAllCredentials() async {
    return await _storage.readAll();
  }
}
