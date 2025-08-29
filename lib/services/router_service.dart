// lib/services/router_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartssh2/dartssh2.dart';
import 'package:dart_telnet/dart_telnet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RouterService {
  final _storage = const FlutterSecureStorage();

  // ==============================
  // Salvar / Ler credenciais
  // ==============================
  Future<void> saveCredentials(String routerIp, String username, String password) async {
    await _storage.write(key: 'router_${routerIp}_username', value: username);
    await _storage.write(key: 'router_${routerIp}_password', value: password);
  }

  Future<Map<String, String?>> getCredentials(String routerIp) async {
    final username = await _storage.read(key: 'router_${routerIp}_username');
    final password = await _storage.read(key: 'router_${routerIp}_password');
    return {
      "username": username,
      "password": password,
    };
  }

  // ==============================
  // ASUS – HTTP (Login Web UI)
  // ==============================
  Future<bool> loginAsusHttp(String routerIp) async {
    final creds = await getCredentials(routerIp);
    final username = creds['username'];
    final password = creds['password'];

    if (username == null || password == null) return false;

    try {
      final response = await http.post(
        Uri.parse('http://$routerIp/login.cgi'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'login_authorization': base64Encode(utf8.encode('$username:$password')),
        },
      );

      return response.statusCode == 200 && response.body.contains("asus_token");
    } catch (e) {
      return false;
    }
  }

  // ==============================
  // ASUS – SSH
  // ==============================
  Future<String> connectAsusSSH(String routerIp, String command) async {
    final creds = await getCredentials(routerIp);
    final username = creds['username'];
    final password = creds['password'];
    if (username == null || password == null) return "Credenciais ausentes";

    try {
      final socket = await SSHSocket.connect(routerIp, 22);
      final client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );

      final result = await client.run(command);
      client.close();
      return utf8.decode(result);
    } catch (e) {
      return "Erro SSH: $e";
    }
  }

  // ==============================
  // ASUS – Telnet
  // ==============================
  Future<String> connectAsusTelnet(String routerIp, String command) async {
    final creds = await getCredentials(routerIp);
    final username = creds['username'];
    final password = creds['password'];
    if (username == null || password == null) return "Credenciais ausentes";

    try {
      final telnet = await Telnet.connect(routerIp, port: 23);
      await telnet.login(username, password);
      final response = await telnet.execute(command);
      telnet.close();
      return response;
    } catch (e) {
      return "Erro Telnet: $e";
    }
  }

  // ==============================
  // ASUS – API (JSON-RPC simulada)
  // ==============================
  Future<String> callAsusApi(String routerIp, String method, Map<String, dynamic> params) async {
    final creds = await getCredentials(routerIp);
    final username = creds['username'];
    final password = creds['password'];

    if (username == null || password == null) return "Credenciais ausentes";

    try {
      final response = await http.post(
        Uri.parse('http://$routerIp/appGet.cgi'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "method": method,
          "params": params,
          "id": 1,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Erro API: ${response.statusCode}";
      }
    } catch (e) {
      return "Erro API: $e";
    }
  }
}
