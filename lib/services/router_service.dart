import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RouterCredentials {
  final String ip;
  final String username;
  final String password;

  RouterCredentials({required this.ip, required this.username, required this.password});
}

class RouterService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Salva credenciais criptografadas
  Future<void> saveCredentials(String routerName, RouterCredentials creds) async {
    await _storage.write(key: '${routerName}_ip', value: creds.ip);
    await _storage.write(key: '${routerName}_user', value: creds.username);
    await _storage.write(key: '${routerName}_pass', value: creds.password);
  }

  /// Recupera credenciais
  Future<RouterCredentials?> getCredentials(String routerName) async {
    final ip = await _storage.read(key: '${routerName}_ip');
    final user = await _storage.read(key: '${routerName}_user');
    final pass = await _storage.read(key: '${routerName}_pass');
    if (ip != null && user != null && pass != null) {
      return RouterCredentials(ip: ip, username: user, password: pass);
    }
    return null;
  }

  /// Login automático e coleta de dados
  Future<List<Map<String, dynamic>>> fetchRouterData(List<String> routerNames) async {
    List<Map<String, dynamic>> allDevices = [];

    for (String name in routerNames) {
      final creds = await getCredentials(name);
      if (creds == null) continue;

      // Autenticação
      final token = await _login(creds);
      if (token == null) continue;

      // Coleta de dispositivos
      final devices = await _getClients(creds.ip, token);
      allDevices.addAll(devices);
    }

    return allDevices;
  }

  /// Login no roteador (HTTP/HTTPS)
  Future<String?> _login(RouterCredentials creds) async {
    try {
      final url = Uri.parse('http://${creds.ip}/api/login');
      final response = await http.post(url, body: {
        'username': creds.username,
        'password': creds.password,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; // Ajustar conforme API real do roteador
      }
    } catch (e) {
      print('Erro login ${creds.ip}: $e');
    }
    return null;
  }

  /// Coleta lista de dispositivos conectados
  Future<List<Map<String, dynamic>>> _getClients(String ip, String token) async {
    try {
      final url = Uri.parse('http://$ip/api/clients');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['clients']); // Ajustar conforme API real
      }
    } catch (e) {
      print('Erro fetch clients $ip: $e');
    }
    return [];
  }
}
