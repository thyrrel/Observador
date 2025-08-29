
// [Flutter] lib/adapters/tplink_adapter.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';

class TPLinkAdapter implements RouterAdapter {
  TPLinkAdapter();

  @override
  Future<String?> login(String ip, String username, String password) async {
    // 1) Form login (comum em TP-Link)
    try {
      final uri = Uri.parse('http://$ip/userRpm/LoginRpm.htm?username=$username&password=$password');
      final resp = await http.get(uri).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 302) {
        final setCookie = resp.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) return setCookie;
      }
    } catch (_) {}

    // 2) Basic Auth fallback
    try {
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final uri = Uri.parse('http://$ip/');
      final resp = await http.get(uri, headers: {'Authorization': basicAuth}).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) return basicAuth;
    } catch (_) {}

    // 3) API JSON fallback (alguns modelos usam /api)
    try {
      final apiUri = Uri.parse('http://$ip/api/login');
      final resp = await http.post(apiUri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({
        'username': username,
        'password': password,
      })).timeout(const Duration(seconds: 6));

      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is Map && parsed.containsKey('token')) return parsed['token'].toString();
      }
    } catch (_) {}

    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final List<RouterDevice> devices = [];
    final endpoints = [
      'http://$ip/api/clients',
      'http://$ip/userRpm/AssignedIpAddrListRpm.htm',
      'http://$ip/clients.cgi',
    ];

    for (final ep in endpoints) {
      try {
        final headers = <String, String>{};
        if (token.isNotEmpty) {
          if (token.contains('=')) headers['Cookie'] = token;
          else if (token.toLowerCase().startsWith('basic ')) headers['Authorization'] = token;
          else headers['Authorization'] = 'Bearer $token';
        }

        final uri = Uri.parse(ep);
        final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
        if (resp.statusCode != 200) continue;

        try {
          final parsed = jsonDecode(resp.body);
          final list = _extractListFromJson(parsed);
          if (list.isNotEmpty) {
            return list.map((d) {
              final mac = (d['mac'] ?? d['MAC'] ?? '').toString();
              final name = (d['hostname'] ?? d['name'] ?? '').toString();
              final rx = _toInt(d['rx_bytes'] ?? 0);
              final tx = _toInt(d['tx_bytes'] ?? 0);
              final blocked = (d['blocked'] ?? false) as bool;
              return RouterDevice(mac: mac, name: name, rxBytes: rx, txBytes: tx, blocked: blocked);
            }).toList();
          }
        } catch (_) {
          final htmlDevices = _parseClientsFromHtml(resp.body);
          if (htmlDevices.isNotEmpty) return htmlDevices;
        }
      } catch (_) {}
    }

    return devices;
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    final endpoints = [
      'http://$ip/api/block_client',
      'http://$ip/userRpm/AccessControlRpm.htm?mac=$mac&block=1',
    ];

    for (final ep in endpoints) {
      try {
        final headers = <String, String>{'Content-Type': 'application/json'};
        if (token.contains('=')) headers['Cookie'] = token;
        else if (token.toLowerCase().startsWith('basic ')) headers['Authorization'] = token;
        else headers['Authorization'] = 'Bearer $token';

        final body = jsonEncode({'mac': mac});
        final resp = await http.post(Uri.parse(ep), headers: headers, body: body).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 204) return true;
      } catch (_) {}
    }

    return false;
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    final endpoints = [
      'http://$ip/api/limit_client',
      'http://$ip/userRpm/QoSRpm.htm?action=add&mac=$mac&rate=${limit}kbps',
    ];

    for (final ep in endpoints) {
      try {
        final headers = <String, String>{'Content-Type': 'application/json'};
        if (token.contains('=')) headers['Cookie'] = token;
        else if (token.toLowerCase().startsWith('basic ')) headers['Authorization'] = token;
        else headers['Authorization'] = 'Bearer $token';

        final body = jsonEncode({'mac': mac, 'limit_kbps': limit});
        final resp = await http.post(Uri.parse(ep), headers: headers, body: body).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 204) return true;
      } catch (_) {}
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

  static List _extractListFromJson(dynamic parsed) {
    if (parsed is List) return parsed;
    if (parsed is Map) {
      if (parsed.containsKey('data') && parsed['data'] is List) return parsed['data'];
      if (parsed.containsKey('clients') && parsed['clients'] is List) return parsed['clients'];
      if (parsed.containsKey('result') && parsed['result'] is List) return parsed['result'];
      if (parsed.containsKey('devices') && parsed['devices'] is List) return parsed['devices'];
    }
    return [];
  }

  static List<RouterDevice> _parseClientsFromHtml(String html) {
    final List<RouterDevice> devices = [];
    final macRegex = RegExp(r'([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})');
    final lines = html.split('\n');
    for (var line in lines) {
      final macMatch = macRegex.firstMatch(line);
      if (macMatch != null) {
        final mac = macMatch.group(0) ?? '';
        devices.add(RouterDevice(mac: mac, name: 'Desconhecido', rxBytes: 0, txBytes: 0, blocked: false));
      }
    }
    return devices;
  }
}
