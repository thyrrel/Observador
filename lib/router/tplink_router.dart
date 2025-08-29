// lib/services/routers/tplink_router.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TpLinkRouter {
  final String ip;
  final String username;
  final String password;

  TpLinkRouter({
    required this.ip,
    required this.username,
    required this.password,
  });

  /// Login e obtenção do token de sessão
  Future<String?> login() async {
    final url = Uri.parse('http://$ip/');
    final auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': auth,
        },
      );

      if (response.statusCode == 200) {
        // Normalmente TP-Link retorna um cookie de sessão
        final cookies = response.headers['set-cookie'];
        return cookies;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Obter lista de dispositivos conectados
  Future<List<Map<String, dynamic>>> getConnectedDevices(String? session) async {
    if (session == null) return [];

    final url = Uri.parse('http://$ip/userRpm/WlanStationRpm.htm');
    try {
      final response = await http.get(
        url,
        headers: {
          'Cookie': session,
        },
      );

      if (response.statusCode == 200) {
        // Aqui precisaria fazer parsing do HTML da TP-Link
        // Exemplo fictício de retorno
        return [
          {
            "ip": "192.168.0.101",
            "mac": "AA:BB:CC:DD:EE:FF",
            "hostname": "Dispositivo1"
          },
          {
            "ip": "192.168.0.102",
            "mac": "11:22:33:44:55:66",
            "hostname": "Dispositivo2"
          }
        ];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Bloquear dispositivo pelo MAC
  Future<bool> blockDevice(String? session, String macAddress) async {
    if (session == null) return false;

    final url = Uri.parse(
        'http://$ip/userRpm/AccessCtrlAccessRulesRpm.htm?mac=$macAddress&block=1');

    try {
      final response = await http.get(
        url,
        headers: {
          'Cookie': session,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Desbloquear dispositivo pelo MAC
  Future<bool> unblockDevice(String? session, String macAddress) async {
    if (session == null) return false;

    final url = Uri.parse(
        'http://$ip/userRpm/AccessCtrlAccessRulesRpm.htm?mac=$macAddress&block=0');

    try {
      final response = await http.get(
        url,
        headers: {
          'Cookie': session,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
