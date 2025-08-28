// [Flutter] /lib/adapters/huawei_adapter.dart
import 'router_adapter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HuaweiAdapter implements RouterAdapter {
  @override
  Future<String?> login(String ip, String username, String password) async {
    final response = await http.post(
      Uri.parse('http://$ip/api/login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['session_id'];
    }
    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final response = await http.get(
      Uri.parse('http://$ip/api/connected_devices'),
      headers: {'Authorization': 'Session $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((d) => RouterDevice(
        mac: d['mac'],
        name: d['hostname'],
        rxBytes: d['rx_bytes'],
        txBytes: d['tx_bytes'],
        blocked: d['blocked'] ?? false,
      )).toList();
    }
    return [];
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    final response = await http.post(
