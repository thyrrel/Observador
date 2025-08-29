import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RouterCredentialsService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveCredentials(String routerIP, String username, String password) async {
    await _storage.write(key: 'router_$routerIP', value: '$username|$password');
  }

  Future<Map<String, String>?> getCredentials(String routerIP) async {
    String? data = await _storage.read(key: 'router_$routerIP');
    if (data != null) {
      var parts = data.split('|');
      return {'username': parts[0], 'password': parts[1]};
    }
    return null;
  }
}
