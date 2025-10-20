// /lib/adapters/routers/intelbras_adapter.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 IntelbrasAdapter - Controle de roteadores Intelbras ┃
// ┃ 🔐 Login, clientes, bloqueio, desbloqueio, limite ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/device_model.dart';
import '../../models/router_device.dart'; // 💡 CORREÇÃO: Adicionada importação para RouterDevice
import 'router_adapter.dart';
import 'router_session.dart';
import 'router_type.dart';

class IntelbrasAdapter implements RouterAdapter {
  final bool debugMode;
  IntelbrasAdapter({this.debugMode = false});

  @override
  Future<RouterSession?> login(String ip, String username, String password) async {
    try {
      final uri = Uri.parse('http://$ip/login.cgi');
      final resp = await http.post(uri, body: {
        'user': username,
        'pass': password,
      }).timeout(const Duration(seconds: 6));

      if (resp.statusCode == 200) {
        final cookie = resp.headers['set-cookie'] ?? 'intelbras_session';
        return RouterSession(token: cookie, type: RouterType.Intelbras);
      }
    } catch (e) {
      if (debugMode) print('[IntelbrasAdapter] login error: $e');
    }
    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final endpoints = ['http://$ip/status.cgi?clients'];
    return _genericClientsRequest(endpoints, token);
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    final endpoints = ['http://$ip/block.cgi'];
    return _genericPost(endpoints, token, {'mac': mac, 'action': 'block'});
  }

  @override
  Future<bool> unblockDevice(String ip, String token, String mac) async {
    final endpoints = ['http://$ip/block.cgi'];
    return _genericPost(endpoints, token, {'mac': mac, 'action': 'unblock'});
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    final endpoints = ['http://$ip/limit.cgi'];
    return _genericPost(endpoints, token, {
      'mac': mac,
      'limit_kbps': limit * 1024,
    });
  }

  @override
  Future<bool> removeLimit(String ip, String token, String mac) async {
    final endpoints = ['http://$ip/limit.cgi'];
    return _genericPost(endpoints, token, {'mac': mac, 'action': 'remove'});
  }

  // 🔧 Helpers
  Future<List<RouterDevice>> _genericClientsRequest(List<String> endpoints, String token) async {
    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = {'Cookie': token};
        final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
        if (resp.statusCode != 200) continue;

        final parsed = jsonDecode(resp.body);
        final rawList = _extractDevicesList(parsed);
        return rawList.map<RouterDevice>((d) {
          final mac = (d['mac'] ?? d['hwaddr'] ?? '').toString();
          final name = (d['name'] ?? d['hostname'] ?? '').toString();
          final rx = _toInt(d['rx_bytes'] ?? d['rx'] ?? 0);
          final tx = _toInt(d['tx_bytes'] ?? d['tx'] ?? 0);
          final blocked = (d['blocked'] ?? false) as bool;
          return RouterDevice(mac: mac, name: name, rxBytes: rx, txBytes: tx, blocked: blocked);
        }).toList();
      } catch (e) {
        if (debugMode) print('[IntelbrasAdapter] client fetch error: $e');
      }
    }
    return [];
  }

  Future<bool> _genericPost(List<String> endpoints, String token, Map<String, dynamic> body) async {
    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = {'Content-Type': 'application/json', 'Cookie': token};
        final resp = await http.post(uri, headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 204) return true;
      } catch (e) {
        if (debugMode) print('[IntelbrasAdapter] post error: $e');
      }
    }
    return false;
  }

  List<Map<String, dynamic>> _extractDevicesList(dynamic parsed) {
    final rawList = switch (parsed) {
      List l => l,
      Map m => m['data'] ?? m['result'] ?? m['clients'] ?? m['devices'] ?? [],
      _ => [],
    };

    return rawList is List
        ? rawList.whereType<Map<String, dynamic>>().toList()
        : [];
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is double) return v.toInt();
    return 0;
  }
}
