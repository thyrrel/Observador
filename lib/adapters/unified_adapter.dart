// [Flutter] lib/adapters/unified_adapter.dart
// Adapter unificado para D-Link, Huawei, MikroTik, Xiaomi e TP-Link
// Todos seguem o padrão RouterAdapter

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';

class UnifiedAdapter implements RouterAdapter {
  UnifiedAdapter();

  // --------------------
  // LOGIN
  // --------------------
  @override
  Future<String?> login(String ip, String username, String password) async {
    final adapters = [
      _loginDLink,
      _loginHuawei,
      _loginMikrotik,
      _loginXiaomi,
      _loginTPLink,
    ];

    for (var loginFunc in adapters) {
      final token = await loginFunc(ip, username, password);
      if (token != null) return token;
    }
    return null;
  }

  Future<String?> _loginDLink(String ip, String username, String password) async {
    try {
      final uri = Uri.parse('http://$ip/login.cgi');
      final resp = await http.post(uri, body: {'username': username, 'password': password}).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 302) {
        final setCookie = resp.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) return setCookie;
      }
    } catch (_) {}
    return null;
  }

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

  Future<String?> _loginMikrotik(String ip, String username, String password) async {
    try {
      final basic = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final resp = await http.get(Uri.parse('http://$ip/rest/'), headers: {'Authorization': basic}).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 401) return basic;
    } catch (_) {}
    return null;
  }

  Future<String?> _loginXiaomi(String ip, String username, String password) async {
    try {
      final uri = Uri.parse('http://$ip/cgi-bin/luci/rpc/auth');
      final resp = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password})).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data.containsKey('token')) return data['token'].toString();
      }
    } catch (_) {}
    return null;
  }

  Future<String?> _loginTPLink(String ip, String username, String password) async {
    try {
      final basic = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final resp = await http.get(Uri.parse('http://$ip/'), headers: {'Authorization': basic}).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) return basic;
    } catch (_) {}
    return null;
  }

  // --------------------
  // GET CLIENTS
  // --------------------
  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final clientsFuncs = [
      _getDLinkClients,
      _getHuaweiClients,
      _getMikrotikClients,
      _getXiaomiClients,
      _getTPLinkClients,
    ];

    for (var func in clientsFuncs) {
      final list = await func(ip, token);
      if (list.isNotEmpty) return list;
    }
    return [];
  }

  Future<List<RouterDevice>> _getDLinkClients(String ip, String token) async {
    try {
      final uri = Uri.parse('http://$ip/api/clients');
      final headers = _tokenToHeader(token);
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) return _parseDeviceList(jsonDecode(resp.body));
    } catch (_) {}
    return [];
  }

  Future<List<RouterDevice>> _getHuaweiClients(String ip, String token) async {
    try {
      final uri = Uri.parse('http://$ip/api/connected_devices');
      final headers = _tokenToHeader(token);
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body) as List;
        return parsed
            .map((d) => RouterDevice(
                  mac: d['mac'],
                  name: d['hostname'],
                  rxBytes: d['rx_bytes'] ?? 0,
                  txBytes: d['tx_bytes'] ?? 0,
                  blocked: d['blocked'] ?? false,
                ))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<RouterDevice>> _getMikrotikClients(String ip, String token) async {
    final devices = <RouterDevice>[];
    final headers = _tokenToHeader(token);

    try {
      final uri = Uri.parse('http://$ip/rest/ip/dhcp-server/lease');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body) as List;
        for (var item in parsed) {
          devices.add(RouterDevice(
              mac: item['mac-address'],
              name: item['host-name'] ?? item['address'],
              rxBytes: 0,
              txBytes: 0,
              blocked: false));
        }
        if (devices.isNotEmpty) return devices;
      }
    } catch (_) {}
    return devices;
  }

  Future<List<RouterDevice>> _getXiaomiClients(String ip, String token) async {
    final endpoints = [
      'http://$ip/cgi-bin/luci/;stok=/api/misystem/devices',
      'http://$ip/api/misystem/device_list',
    ];
    for (var ep in endpoints) {
      try {
        final resp = await http.get(Uri.parse(ep), headers: _tokenToHeader(token)).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200) {
          final parsed = jsonDecode(resp.body);
          final list = _parseDeviceList(parsed);
          if (list.isNotEmpty) return list;
        }
      } catch (_) {}
    }
    return [];
  }

  Future<List<RouterDevice>> _getTPLinkClients(String ip, String token) async {
    try {
      final uri = Uri.parse('http://$ip/clients');
      final resp = await http.get(uri, headers: _tokenToHeader(token)).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) return _parseDeviceList(jsonDecode(resp.body));
    } catch (_) {}
    return [];
  }

  // --------------------
  // BLOCK DEVICE
  // --------------------
  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    final funcs = [_blockDLink, _blockHuawei, _blockMikrotik, _blockXiaomi, _blockTPLink];
    for (var f in funcs) {
      if (await f(ip, token, mac)) return true;
    }
    return false;
  }

  Future<bool> _blockDLink(String ip, String token, String mac) async {
    return _genericPost(ip, token, '/api/block_client', {'mac': mac});
  }

  Future<bool> _blockHuawei(String ip, String token, String mac) async {
    return _genericPost(ip, token, '/api/block_client', {'mac': mac});
  }

  Future<bool> _blockMikrotik(String ip, String token, String mac) async {
    return _genericPost(ip, token, '/rest/ip/firewall/address-list', {'list': 'blocked', 'address': mac});
  }

  Future<bool> _blockXiaomi(String ip, String token, String mac) async {
    return _genericPost(ip, token, '/api/block_client', {'mac': mac});
  }

  Future<bool> _blockTPLink(String ip, String token, String mac) async {
    return _genericPost(ip, token, '/api/block_client', {'mac': mac});
  }

  // --------------------
  // LIMIT DEVICE
  // --------------------
  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    final funcs = [_limitDLink, _limitHuawei, _limitMikrotik, _limitXiaomi, _limitTPLink];
    for (var f in funcs) {
      if (await f(ip, token, mac, limit)) return true;
    }
    return false;
  }

  Future<bool> _limitDLink(String ip, String token, String mac, int limit) async {
    return _genericPost(ip, token, '/api/limit_client', {'mac': mac, 'limit_kbps': limit * 1024});
  }

  Future<bool> _limitHuawei(String ip, String token, String mac, int limit) async {
    return _genericPost(ip, token, '/api/limit_client', {'mac': mac, 'limit_kbps': limit * 1024});
  }

  Future<bool> _limitMikrotik(String ip, String token, String mac, int limit) async {
    return _genericPost(ip, token, '/rest/queue/simple', {
      'name': 'obs-${mac.replaceAll(":", "")}',
      'target': mac,
      'max-limit': '${limit}k/${limit}k'
    });
  }

  Future<bool> _limitXiaomi(String ip, String token, String mac, int limit) async {
    return _genericPost(ip, token, '/api/limit_client', {'mac': mac, 'limit_kbps': limit * 1024});
  }

  Future<bool> _limitTPLink(String ip, String token, String mac, int limit) async {
    return _genericPost(ip, token, '/api/limit_client', {'mac': mac, 'limit_kbps': limit * 1024});
  }

  // --------------------
  // GENERIC POST
  // --------------------
  Future<bool> _genericPost(String ip, String token, String path, Map<String, dynamic> payload) async {
    try {
      final uri = Uri.parse('http://$ip$path');
      final resp = await http.post(uri, headers: _tokenToHeader(token)..addAll({'Content-Type': 'application/json'}), body: jsonEncode(payload)).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 204) return true;
    } catch (_) {}
    return false;
  }

  // --------------------
  // HELPERS
  // --------------------
  Map<String, String> _tokenToHeader(String token) {
    if (token.contains('=')) return {'Cookie': token, 'Accept': 'application/json'};
    if (token.toLowerCase().startsWith('basic ')) return {'Authorization': token, 'Accept': 'application/json'};
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  List<RouterDevice> _parseDeviceList(dynamic parsed) {
    if (parsed is List) return parsed.map((d) => _mapToDevice(d)).toList();
    if (parsed is Map) {
      if (parsed.containsKey('data') && parsed['data'] is List) return parsed['data'].map((d) => _mapToDevice(d)).toList();
      if (parsed.containsKey('result') && parsed['result'] is List) return parsed['result'].map((d) => _mapToDevice(d)).toList();
      if (parsed.containsKey('clients') && parsed['clients'] is List) return parsed['clients'].map((d) => _mapToDevice(d)).toList();
    }
    return [];
  }

  RouterDevice _mapToDevice(dynamic d) {
    final mac = (d['mac'] ?? d['hwaddr'] ?? '').toString();
    final name = (d['name'] ?? d['hostname'] ?? d['host'] ?? mac).toString();
    final rx = _toInt(d['rx_bytes'] ?? d['rx'] ?? 0);
    final tx = _toInt(d['tx_bytes'] ?? d['tx'] ?? 0);
    final blocked = d['blocked'] ?? false;
    return RouterDevice(mac: mac, name: name, rxBytes: rx, txBytes: tx, blocked: blocked);
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is double) return v.toInt();
    return 0;
  }
}
