// [Flutter] /lib/adapters/huawei_adapter.dart
import 'router_adapter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HuaweiAdapter implements RouterAdapter {
  HuaweiAdapter();

  @override
  Future<String?> login(String ip, String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/api/login'),
            body: {'username': username, 'password': password},
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['session_id']?.toString();
      } else {
        print('Huawei login failed, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Huawei login exception: $e');
    }
    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('http://$ip/api/connected_devices'),
            headers: {'Authorization': 'Session $token'},
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((d) {
          return RouterDevice(
            mac: d['mac'] ?? '',
            name: d['hostname'] ?? 'Unknown',
            rxBytes: _toInt(d['rx_bytes']),
            txBytes: _toInt(d['tx_bytes']),
            blocked: d['blocked'] ?? false,
          );
        }).toList();
      } else {
        print('Huawei getClients failed, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Huawei getClients exception: $e');
    }
    return [];
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/api/block_device'),
            headers: {'Authorization': 'Session $token', 'Content-Type': 'application/json'},
            body: jsonEncode({'mac': mac}),
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200 || response.statusCode == 204) return true;
      print('Huawei blockDevice failed, status: ${response.statusCode}');
    } catch (e) {
      print('Huawei blockDevice exception: $e');
    }
    return false;
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/api/limit_device'),
            headers: {'Authorization': 'Session $token', 'Content-Type': 'application/json'},
            body: jsonEncode({'mac': mac, 'limit_kbps': limit}),
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200 || response.statusCode == 204) return true;
      print('Huawei limitDevice failed, status: ${response.statusCode}');
    } catch (e) {
      print('Huawei limitDevice exception: $e');
    }
    return false;
  }

  // --------------------
  // Helpers
  // --------------------
  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is double) return v.toInt();
    return 0;
  }
}
