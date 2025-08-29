// [Flutter] lib/adapters/unified_adapter.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';

enum RouterType { dlink, huawei, mikrotik, xiaomi, tplink, unknown }

class UnifiedAdapter implements RouterAdapter {
  final RouterType routerType;

  UnifiedAdapter({this.routerType = RouterType.unknown});

  @override
  Future<String?> login(String ip, String username, String password) async {
    switch (routerType) {
      case RouterType.dlink:
        return _loginDLink(ip, username, password);
      case RouterType.huawei:
        return _loginHuawei(ip, username, password);
      case RouterType.mikrotik:
        return _loginMikrotik(ip, username, password);
      case RouterType.xiaomi:
        return _loginXiaomi(ip, username, password);
      case RouterType.tplink:
        return null; // placeholder
      default:
        return null;
    }
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    switch (routerType) {
      case RouterType.dlink:
        return _getClientsDLink(ip, token);
      case RouterType.huawei:
        return _getClientsHuawei(ip, token);
      case RouterType.mikrotik:
        return _getClientsMikrotik(ip, token);
      case RouterType.xiaomi:
        return _getClientsXiaomi(ip, token);
      case RouterType.tplink:
        return [];
      default:
        return [];
    }
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    switch (routerType) {
      case RouterType.dlink:
        return _blockDeviceDLink(ip, token, mac);
      case RouterType.huawei:
        return _blockDeviceHuawei(ip, token, mac);
      case RouterType.mikrotik:
        return _blockDeviceMikrotik(ip, token, mac);
      case RouterType.xiaomi:
        return _blockDeviceXiaomi(ip, token, mac);
      case RouterType.tplink:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    switch (routerType) {
      case RouterType.dlink:
        return _limitDeviceDLink(ip, token, mac, limit);
      case RouterType.huawei:
        return _limitDeviceHuawei(ip, token, mac, limit);
      case RouterType.mikrotik:
        return _limitDeviceMikrotik(ip, token, mac, limit);
      case RouterType.xiaomi:
        return _limitDeviceXiaomi(ip, token, mac, limit);
      case RouterType.tplink:
        return false;
      default:
        return false;
    }
  }

  // -----------------------
  // D-Link
  // -----------------------
  Future<String?> _loginDLink(String ip, String username, String password) async {
    try {
      final formUri = Uri.parse('http://$ip/login.cgi');
      final resp = await http.post(formUri, body: {'username': username, 'password': password}).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 302) {
        final cookie = resp.headers['set-cookie'];
        if (cookie != null) return cookie;
      }
    } catch (_) {}
    return null;
  }

  Future<List<RouterDevice>> _getClientsDLink(String ip, String token) async {
    // Similar à implementação do dlink_adapter.dart
    return [];
  }

  Future<bool> _blockDeviceDLink(String ip, String token, String mac) async {
    return false;
  }

  Future<bool> _limitDeviceDLink(String ip, String token, String mac, int limit) async {
    return false;
  }

  // -----------------------
  // Huawei
  // -----------------------
  Future<String?> _loginHuawei(String ip, String username, String password) async {
    try {
      final resp = await http.post(Uri.parse('http://$ip/api/login'), body: {'username': username, 'password': password});
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['session_id'];
      }
    } catch (_) {}
    return null;
  }

  Future<List<RouterDevice>> _getClientsHuawei(String ip, String token) async {
    return [];
  }

  Future<bool> _blockDeviceHuawei(String ip, String token, String mac) async {
    return false;
  }

  Future<bool> _limitDeviceHuawei(String ip, String token, String mac, int limit) async {
    return false;
  }

  // -----------------------
  // MikroTik
  // -----------------------
  Future<String?> _loginMikrotik(String ip, String username, String password) async {
    try {
      final basic = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final resp = await http.get(Uri.parse('http://$ip/rest/'), headers: {'Authorization': basic}).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 401) return basic;
    } catch (_) {}
    return null;
  }

  Future<List<RouterDevice>> _getClientsMikrotik(String ip, String token) async {
    return [];
  }

  Future<bool> _blockDeviceMikrotik(String ip, String token, String mac) async {
    return false;
  }

  Future<bool> _limitDeviceMikrotik(String ip, String token, String mac, int limit) async {
    return false;
  }

  // -----------------------
  // Xiaomi
  // -----------------------
  Future<String?> _loginXiaomi(String ip, String username, String password) async {
    return null;
  }

  Future<List<RouterDevice>> _getClientsXiaomi(String ip, String token) async {
    return [];
  }

  Future<bool> _blockDeviceXiaomi(String ip, String token, String mac) async {
    return false;
  }

  Future<bool> _limitDeviceXiaomi(String ip, String token, String mac, int limit) async {
    return false;
  }
}
