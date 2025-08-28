// [Flutter] /lib/adapters/xiaomi_adapter.dart
import 'router_adapter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class XiaomiAdapter implements RouterAdapter {
  @override
  Future<String?> login(String ip, String username, String password) async {
    // Exemplo: chamada HTTP para login Xiaomi
    final response = await http.post(
      Uri.parse('http://$ip/cgi-bin/luci'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      // Extraia token da resposta (simulado aqui)
      final data = jsonDecode(response.body);
      return data['token'];
    }
    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final response = await http.get(
      Uri.parse('http://$ip/api/clients'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((d) => RouterDevice(
        mac: d['mac'],
        name: d['name'],
        rxBytes: d['rx_bytes'],
        txBytes: d['tx_bytes'],
        blocked: d['blocked'],
      )).toList();
    }
    return [];
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    final response = await http.post(
      Uri.parse('http://$ip/api/block'),
      headers: {'Authorization': 'Bearer $token'},
      body: {'mac': mac},
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    final response = await http.post(
      Uri.parse('http://$ip/api/limit'),
      headers: {'Authorization': 'Bearer $token'},
      body: {'mac': mac, 'limit': limit.toString()},
    );
    return response.statusCode == 200;
  }
}
