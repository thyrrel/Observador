// lib/services/router_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

enum RouterType { huawei, xiaomi, tplink, asus }

class RouterService {
  final RouterType type;
  final String ip;
  String username;
  String password;
  bool _loggedIn = false;

  RouterService({
    required this.type,
    required this.ip,
    required this.username,
    required this.password,
  });

  // Mapa de credenciais padrão
  static const Map<RouterType, Map<String, String>> defaultCredentials = {
    RouterType.huawei: {'username': 'admin', 'password': 'admin'},
    RouterType.xiaomi: {'username': 'admin', 'password': 'admin'},
    RouterType.tplink: {'username': 'admin', 'password': 'admin'},
    RouterType.asus: {'username': 'admin', 'password': 'admin'},
  };

  // Login principal com fallback automático
  Future<bool> login() async {
    bool success = await _attemptLogin(username, password);
    if (!success) {
      final defaults = defaultCredentials[type]!;
      username = defaults['username']!;
      password = defaults['password']!;
      success = await _attemptLogin(username, password);
    }
    _loggedIn = success;
    return success;
  }

  Future<bool> _attemptLogin(String user, String pass) async {
    try {
      switch (type) {
        case RouterType.huawei:
          return await _loginHuawei(user, pass);
        case RouterType.xiaomi:
          return await _loginXiaomi(user, pass);
        case RouterType.tplink:
          return await _loginTplink(user, pass);
        case RouterType.asus:
          return await _loginAsus(user, pass);
      }
    } catch (_) {}
    return false;
  }

  // --- Métodos de login específicos por marca ---
  Future<bool> _loginHuawei(String user, String pass) async {
    final url = Uri.parse('http://$ip/api/user/login');
    final body = '<request><Username>$user</Username><Password>$pass</Password></request>';
    final response = await http.post(url, body: body, headers: {'Content-Type': 'application/xml'});
    return response.statusCode == 200 && response.body.contains('<response>OK</response>');
  }

  Future<bool> _loginXiaomi(String user, String pass) async {
    final url = Uri.parse('http://$ip/cgi-bin/luci');
    final response = await http.get(url, headers: {'Authorization': 'Basic ' + base64Encode(utf8.encode('$user:$pass'))});
    return response.statusCode == 200;
  }

  Future<bool> _loginTplink(String user, String pass) async {
    final url = Uri.parse('http://$ip/userRpm/LoginRpm.htm?Save=Save');
    final response = await http.get(url, headers: {'Authorization': 'Basic ' + base64Encode(utf8.encode('$user:$pass'))});
    return response.statusCode == 200;
  }

  Future<bool> _loginAsus(String user, String pass) async {
    final url = Uri.parse('http://$ip/login.cgi');
    final response = await http.post(url, body: {'username': user, 'password': pass});
    return response.statusCode == 200 && response.body.contains('login_success');
  }

  // --- Funções de controle ---
  Future<bool> blockIP(String targetIP) async {
    if (!_loggedIn) return false;
    switch (type) {
      case RouterType.huawei:
        return await _blockHuawei(targetIP);
      case RouterType.xiaomi:
        return await _blockXiaomi(targetIP);
      case RouterType
