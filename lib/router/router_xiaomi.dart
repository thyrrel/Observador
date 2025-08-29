// lib/services/routers/router_xiaomi.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouterXiaomi {
  final String ip;
  final String username;
  final String password;
  String? token;

  RouterXiaomi({
    required this.ip,
    required this.username,
    required this.password,
  });

  /// Autentica no roteador e obtém token de sessão
  Future<bool> login() async {
    final url = Uri.parse('http://$ip/cgi-bin/luci/;stok=/login?form=login');
    final body = {
      "operation": "login",
      "username": username,
      "password": password
    };

    try {
      final response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['token'];
        return true;
      }
    } catch (e) {
      print('Erro login Xiaomi: $e');
    }
    return false;
  }

  /// Bloqueia um dispositivo pelo MAC
  Future<bool> blockDevice(String mac) async {
    if (token == null) return false;
    final url = Uri.parse('http://$ip/cgi-bin/luci/;stok=$token/api/misystem/acl');
    final body = {
      "operation": "add",
      "mac": mac,
      "action": "block"
    };
    try {
      final response = await http.post(url, body: jsonEncode(body));
      return response.statusCode == 200;
    } catch (e) {
      print('Erro bloquear dispositivo Xiaomi: $e');
      return false;
    }
  }

  /// Libera um dispositivo bloqueado
  Future<bool> unblockDevice(String mac) async {
    if (token == null) return false;
    final url = Uri.parse('http://$ip/cgi-bin/luci/;stok=$token/api/misystem/acl');
    final body = {
      "operation": "remove",
      "mac": mac,
    };
    try {
      final response = await http.post(url, body: jsonEncode(body));
      return response.statusCode == 200;
    } catch (e) {
      print('Erro desbloquear dispositivo Xiaomi: $e');
      return false;
    }
  }

  /// Limita velocidade de um dispositivo (em Kbps)
  Future<bool> limitDevice(String mac, int speedKbps) async {
    if (token == null) return false;
    final url = Uri.parse('http://$ip/cgi-bin/luci/;stok=$token/api/misystem/qos');
    final body = {
      "operation": "set",
      "mac": mac,
      "limit": speedKbps
    };
    try {
      final response = await http.post(url, body: jsonEncode(body));
      return response.statusCode == 200;
    } catch (e) {
      print('Erro limitar dispositivo Xiaomi: $e');
      return false;
    }
  }
}
