// [Flutter] lib/adapters/router_unified_adapter.dart
// Adaptador unificado para múltiplos roteadores (Xiaomi, TP-Link, Huawei)
// Mantém compatibilidade com RouterAdapter e facilita extensão futura

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device_model.dart';

enum RouterType { Xiaomi, TPLink, Huawei }

abstract class RouterAdapter {
  Future<String?> login(String ip, String username, String password);
  Future<List<RouterDevice>> getClients(String ip, String token);
  Future<bool> blockDevice(String ip, String token, String mac);
  Future<bool> limitDevice(String ip, String token, String mac, int limit);
}

class RouterUnifiedAdapter implements RouterAdapter {
  final RouterType type;
  RouterUnifiedAdapter(this.type);

  @override
  Future<String?> login(String ip, String username, String password) async {
    switch (type) {
      case RouterType.Xiaomi:
        return _xiaomiLogin(ip, username, password);
      case RouterType.TPLink:
        return _tplinkLogin(ip, username, password);
      case RouterType.Huawei:
        return _huaweiLogin(ip, username, password);
    }
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    switch (type) {
      case RouterType.Xiaomi:
        return _xiaomiClients(ip, token);
      case RouterType.TPLink:
        return _tplinkClients(ip, token);
      case RouterType.Huawei:
        return _huaweiClients(ip, token);
    }
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    switch (type) {
      case RouterType.Xiaomi:
        return _xiaomiBlock(ip, token, mac);
      case RouterType.TPLink:
        return _tplinkBlock(ip, token, mac);
      case RouterType.Huawei:
        return _huaweiBlock(ip, token, mac);
    }
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    switch (type) {
      case RouterType.Xiaomi:
        return _xiaomiLimit(ip, token, mac, limit);
      case RouterType.TPLink:
        return _tplinkLimit(ip, token, mac, limit);
      case RouterType.Huawei:
        return _huaweiLimit(ip, token, mac, limit);
    }
  }

  // -------------------- Xiaomi --------------------
  Future<String?> _xiaomiLogin(String ip, String username, String password) async {
    try {
      final uri = Uri.parse('http://$ip/cgi-bin/luci/rpc/auth');
      final resp = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}))
        .timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is Map && data.containsKey('token')) return data['token'].toString();
      }
    } catch (_) {}
    return null;
  }

  Future<List<RouterDevice>> _xiaomiClients(String ip, String token) async {
    final endpoints = [
      'http://$ip/cgi-bin/luci/;stok=/api/misystem/devices',
      'http://$ip/api/misystem/device_list',
    ];
    return _genericClientsRequest(endpoints, token);
  }

  Future<bool> _xiaomiBlock(String ip, String token, String mac) async {
    final endpoints = [
      'http://$ip/api/block_client',
      'http://$ip/cgi-bin/luci/;stok=/api/misystem/block',
    ];
    return _genericPost(endpoints, token, {'mac': mac});
  }

  Future<bool> _xiaomiLimit(String ip, String token, String mac, int limit) async {
    final endpoints = [
      'http://$ip/api/limit_client',
      'http://$ip/cgi-bin/luci/;stok=/api/misystem/limit',
    ];
    return _genericPost(endpoints, token, {'mac': mac, 'limit_kbps': limit * 1024});
  }

  // -------------------- TP-Link --------------------
  Future<String?> _tplinkLogin(String ip, String username, String password) async {
    try {
      final uri = Uri.parse('http://$ip/userRpm/LoginRpm.htm?Save=Save');
      final resp = await http.post(uri, body: {'username': username, 'password': password})
          .timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 302) {
        final setCookie = resp.headers['set-cookie'];
        if (setCookie != null) return setCookie;
      }
    } catch (_) {}
    return null;
  }

  Future<List<RouterDevice>> _tplinkClients(String ip, String token) async {
    final endpoints = ['http://$ip/userRpm/AccessControlRpm.htm'];
    return _genericClientsRequest(endpoints, token);
  }

  Future<bool> _tplinkBlock(String ip, String token, String mac) async {
    final endpoints = ['http://$ip/userRpm/AccessCtrlAccessRulesRpm.htm?mac=$mac&block=1'];
    return _genericPost(endpoints, token, {});
  }

  Future<bool> _tplinkLimit(String ip, String token, String mac, int limit) async {
    // Placeholder TP-Link: muitos firmwares não oferecem limite via API pública
    return false;
  }

  // -------------------- Huawei --------------------
  Future<String?> _huaweiLogin(String ip, String username, String password) async {
    // Exemplo básico: form login
    try {
      final uri = Uri.parse('http://$ip/');
      final resp = await http.post(uri, body: {'Username': username, 'Password': password})
          .timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) return 'token_dummy_huawei';
    } catch (_) {}
    return null;
  }

  Future<List<RouterDevice>> _huaweiClients(String ip, String token) async {
    final endpoints = ['http://$ip/api/clients'];
    return _genericClientsRequest(endpoints, token);
  }

  Future<bool> _huaweiBlock(String ip, String token, String mac) async {
    final endpoints = ['http://$ip/api/block_client'];
    return _genericPost(endpoints, token, {'mac': mac});
  }

  Future<bool> _huaweiLimit(String ip, String token, String mac, int limit) async {
    final endpoints = ['http://$ip/api/limit_client'];
    return _genericPost(endpoints, token, {'mac': mac, 'limit_kbps': limit * 1024});
  }

  // -------------------- Helpers genéricos --------------------
  Future<List<RouterDevice>> _genericClientsRequest(List<String> endpoints, String token) async {
    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = <String, String>{};
        if (token.contains('=')) headers['Cookie'] = token;
        else headers['Authorization'] = 'Bearer $token';

        final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
        if (resp.statusCode != 200) continue;
        final parsed = jsonDecode(resp.body);
        final List devicesList = _extractDevicesList(parsed);
        if (devicesList.isNotEmpty) {
          return devicesList.map<RouterDevice>((d) {
            final mac = (d['mac'] ?? d['hwaddr'] ?? '').toString();
            final name = (d['name'] ?? d['hostname'] ?? '').toString();
            final rx = _toInt(d['rx_bytes'] ?? d['rx'] ?? 0);
            final tx = _toInt(d['tx_bytes'] ?? d['tx'] ?? 0);
            final blocked = (d['blocked'] ?? false) as bool;
            return RouterDevice(mac: mac, name: name, rxBytes: rx, txBytes: tx, blocked: blocked);
          }).toList();
        }
      } catch (_) {}
    }
    return [];
  }

  Future<bool> _genericPost(List<String> endpoints, String token, Map<String, dynamic> body) async {
    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = {'Content-Type': 'application/json'};
        if (token.contains('=')) headers['Cookie'] = token;
        else headers['Authorization'] = 'Bearer $token';
        final resp = await http.post(uri, headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 204) return true;
      } catch (_) {}
    }
    return false;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is double) return v.toInt();
    return 0;
  }

  static List _extractDevicesList(dynamic parsed) {
    if (parsed is List) return parsed;
    if (parsed is Map) {
      if (parsed.containsKey('data') && parsed['data'] is List) return parsed['data'];
      if (parsed.containsKey('result') && parsed['result'] is List) return parsed['result'];
      if (parsed.containsKey('clients') && parsed['clients'] is List) return parsed['clients'];
      if (parsed.containsKey('devices') && parsed['devices'] is List) return parsed['devices'];
    }
    return [];
  }
}
