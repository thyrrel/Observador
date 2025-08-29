// [Flutter] lib/adapters/dlink_adapter.dart
// Adaptador D-Link para uso com RouterAdapter
// Requer: package:http/http.dart as http
// Ajuste endpoints se seu modelo D-Link usar caminhos diferentes.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';
import 'package:html/parser.dart' as html_parser;

class DLinkAdapter implements RouterAdapter {
  DLinkAdapter();

  /// Tenta autenticar: 1) form login 2) basic auth 3) API token
  @override
  Future<String?> login(String ip, String username, String password) async {
    // 1) Tentar login via form (common in older D-Link)
    try {
      final formUri = Uri.parse('http://$ip/login.cgi');
      final formResp = await http
          .post(
            formUri,
            body: {'username': username, 'password': password},
          )
          .timeout(const Duration(seconds: 6));

      if (formResp.statusCode == 200 || formResp.statusCode == 302) {
        final setCookie = formResp.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) return setCookie;
        // Alguns modelos retornam JSON com token
        try {
          final bodyJson = jsonDecode(formResp.body);
          if (bodyJson is Map && (bodyJson['token'] ?? bodyJson['sid']) != null) {
            return (bodyJson['token'] ?? bodyJson['sid']).toString();
          }
        } catch (_) {}
      }
    } catch (e) {
      print('DLink Form login failed: $e');
    }

    // 2) Tentar Basic Auth
    try {
      final uri = Uri.parse('http://$ip/');
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final resp = await http
          .get(uri, headers: {'Authorization': basicAuth})
          .timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) return basicAuth;
    } catch (e) {
      print('DLink Basic Auth failed: $e');
    }

    // 3) Tentar token via API (alguns modelos usam /api/login or /cgi-bin)
    try {
      final apiUri = Uri.parse('http://$ip/api/login');
      final resp = await http
          .post(apiUri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'username': username, 'password': password}))
          .timeout(const Duration(seconds: 6));

      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is Map && parsed.containsKey('token')) return parsed['token'].toString();
      }
    } catch (e) {
      print('DLink API token login failed: $e');
    }

    // Falha
    return null;
  }

  /// Tenta obter lista de clientes por vários endpoints comuns
  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final endpoints = [
      'http://$ip/api/clients',
      'http://$ip/clients.cgi',
      'http://$ip/userRpm/HostRpm.htm',
      'http://$ip/api/dhcp/clients',
    ];

    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = <String, String>{'Accept': 'application/json'};
        if (token.isNotEmpty) {
          if (token.contains('=')) headers['Cookie'] = token;
          else if (token.toLowerCase().startsWith('basic ')) headers['Authorization'] = token;
          else headers['Authorization'] = 'Bearer $token';
        }

        final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
        if (resp.statusCode != 200) continue;

        // Tentar interpretar JSON primeiro
        try {
          final parsed = jsonDecode(resp.body);
          final list = _extractListFromJson(parsed);
          if (list.isNotEmpty) {
            return list.map<RouterDevice>((d) {
              final mac = (d['mac'] ?? d['MAC'] ?? d['hwaddr'] ?? '').toString();
              final name = (d['hostname'] ?? d['name'] ?? d['host'] ?? '').toString();
              final rx = _toInt(d['rx_bytes'] ?? d['rx'] ?? d['download'] ?? 0);
              final tx = _toInt(d['tx_bytes'] ?? d['tx'] ?? d['upload'] ?? 0);
              final blocked = (d['blocked'] ?? d['is_blocked'] ?? false) as bool;
              return RouterDevice(mac: mac, name: name, rxBytes: rx, txBytes: tx, blocked: blocked);
            }).toList();
          }
        } catch (_) {
          final htmlDevices = _parseClientsFromHtml(resp.body);
          if (htmlDevices.isNotEmpty) return htmlDevices;
        }
      } catch (e) {
        print('DLink getClients endpoint failed ($ep): $e');
      }
    }

    return [];
  }

  /// Bloquear dispositivo (tenta endpoints comuns)
  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    final endpoints = [
      'http://$ip/api/block_client',
      'http://$ip/block.cgi',
      'http://$ip/userRpm/AccessControlRpm.htm?mac=$mac&block=1',
      'http://$ip/api/clients/block',
    ];

    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = <String, String>{'Content-Type': 'application/json'};
        if (token.contains('=')) headers['Cookie'] = token;
        else if (token.toLowerCase().startsWith('basic ')) headers['Authorization'] = token;
        else headers['Authorization'] = 'Bearer $token';

        final body = jsonEncode({'mac': mac});
        final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 204) return true;
      } catch (e) {
        print('DLink blockDevice endpoint failed ($ep): $e');
      }
    }

    return false;
  }

  /// Limitar dispositivo (tentativa genérica)
  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    final endpoints = [
      'http://$ip/api/limit_client',
      'http://$ip/userRpm/QoSRpm.htm?action=add&mac=$mac&rate=${limit}kbps',
      'http://$ip/api/qos/limit',
    ];

    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = <String, String>{'Content-Type': 'application/json'};
        if (token.contains('=')) headers['Cookie'] = token;
        else if (token.toLowerCase().startsWith('basic ')) headers['Authorization'] = token;
        else headers['Authorization'] = 'Bearer $token';

        final body = jsonEncode({'mac': mac, 'limit_kbps': limit});
        final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 204) return true;
      } catch (e) {
        print('DLink limitDevice endpoint failed ($ep): $e');
      }
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
    final ipRegex = RegExp(r'(\d{1,3}\.){3}\d{1,3}');
    final document = html_parser.parse(html);

    // busca linhas de tabelas ou listas comuns
    final rows = document.querySelectorAll('tr, li, div');
    for (var row in rows) {
      final line = row.text;
      final macMatch = macRegex.firstMatch(line);
      if (macMatch != null) {
        final mac = macMatch.group(0) ?? '';
        final ipMatch = ipRegex.firstMatch(line);
        final ip = ipMatch?.group(0) ?? '';
        final name = _extractNameFromHtmlLine(line);
        devices.add(RouterDevice(mac: mac, name: name, rxBytes: 0, txBytes: 0, blocked: false));
      }
    }
    return devices;
  }

  static String _extractNameFromHtmlLine(String line) {
    final titleRegex = RegExp(r'>([^<>]{2,60})<');
    final match = titleRegex.firstMatch(line);
    if (match != null) return match.group(1)?.trim() ?? '';
    return 'Unknown';
  }
}
