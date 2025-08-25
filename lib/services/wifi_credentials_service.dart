import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WifiCredentialsService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveCredentials(String ssid, String password) async {
    await _storage.write(key: 'wifi_$ssid', value: password);
  }

  Future<String?> getPassword(String ssid) async {
    return await _storage.read(key: 'wifi_$ssid');
  }
}
