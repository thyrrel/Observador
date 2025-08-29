// [Flutter] lib/adapters/xiaomi_adapter.dart
// Adaptador Xiaomi para uso com RouterAdapter
// Requer: package:http/http.dart as http
// Atenção: endpoints variam por firmware. Ajuste conforme a interface do seu roteador.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';

class XiaomiAdapter implements RouterAdapter {
  XiaomiAdapter();

  /// Tenta autenticar usando múltiplas abordagens comuns (form, RPC, basic)
  /// Retorna um "token" abstrato (pode ser cookie, session id ou token JWT).
  @override
  Future<String?> login(String ip, String username, String password) async {
    // 1) Tentar login por RPC (alguns firmwares MiWiFi)
    try {
      final rpcUri = Uri.parse('http://$ip/cgi-bin/luci/rpc/auth');
      final rpcResp = await http.post(
        rpcUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 6));
      if (rpcResp.statusCode == 200) {
        final data = jsonDecode(rpcResp.body);
        if (data is Map && data.containsKey('token')) {
          return data['token'].toString();
        }
      }
    } catch (_) {}

    // 2) Tentar login por form (ex.: /cgi-bin/luci)
    try {
      final formUri = Uri.parse('http://$ip/cgi-bin/luci');
      final formResp = await http.post(
        formUri,
        body: {'username': username, 'password': password},
      ).timeout(const Duration(seconds: 6));

      if (formResp.statusCode == 200 || formResp.statusCode == 302) {
        // Captura cookie de sessão se existir
        final setCookie = formResp.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) {
          return setCookie;
        }
        // Em alguns firmwares a resposta contém token JSON
        try {
          final bodyJson = jsonDecode(formResp.body);
          if (bodyJson is Map && bodyJson.containsKey('token')) {
            return bodyJson['token'].toString();
          }
        } catch (_) {}
      }
    } catch (_) {}

    // 3) Tentar Basic Auth (alguns web GUIs respondem a header Authorization)
    try {
      final basicUri = Uri.parse('http://$ip/');
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final basicResp = await http.get(
        basicUri,
        headers: {'Authorization': basicAuth},
      ).timeout(const Duration(seconds: 5));
      if (basicResp.statusCode == 200) {
        // Retorna o header Authorization usado como token abstrato
        return basicAuth;
      }
    } catch (_) {}

    // Falha de autenticação
    return null;
  }

  /// Obtém clientes conectados. Recebe "token" retornado por login()
  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    // Tenta endpoints JSON comuns; adaptações podem ser necessárias
    final endpoints = [
      'http://$ip/cgi-bin/luci/;stok=/api/misystem/devices', // exemplo MiWiFi
      'http://$ip/api/misystem/device_list', // possível variante
      'http://$ip/cgi-bin/luci/admin/hostapd/clients', // outra possível
      'http://$ip/api/clients', // genérico
    ];

    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = <String, String>{'Accept': 'application/json'};
        // se token parecer cookie
        if (token.contains('=') && token.contains(';')) {
          headers['Cookie'] = token;
        } else if (token.toLowerCase().startsWith('basic ')) {
          headers['Authorization'] = token;
        } else {
          headers['Authorization'] = 'Bearer $token';
        }

        final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
        if (resp.statusCode != 200) continue;

        // Tentar interpretar JSON
        try {
          final parsed = jsonDecode(resp.body);
          // Vários formatos possíveis — tentamos normalizar
          final List devicesList = _extractDevicesList(parsed);
          if (devicesList.isNotEmpty) {
            return devicesList.map<RouterDevice>((d) {
              final mac = (d['mac'] ?? d['hwaddr'] ?? d['mac_address'] ?? '').toString();
              final name = (d['name'] ?? d['hostname'] ?? d['host'] ?? '').toString();
              final rx = _toInt(d['rx_bytes'] ?? d['rx'] ?? d['download'] ?? 0);
              final tx = _toInt(d['tx_bytes'] ?? d['tx'] ?? d['upload'] ?? 0);
              final blocked = (d['blocked'] ?? d['is_blocked'] ?? false) as bool;
              return RouterDevice(mac: mac, name: name, rxBytes: rx, txBytes: tx, blocked: blocked);
            }).toList();
          }
        } catch (_) {
          // Se não for JSON, ignorar e tentar próximo endpoint
        }
      } catch (_) {
        // ignora erro e tenta o próximo endpoint
      }
    }

    // Se não encontrou nada, retorna lista vazia (não é simulação)
    return [];
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    // Endpoints comuns para bloqueio; ajustar conforme firmware
    final endpoints = [
      'http://$ip/api/block_client',
      'http://$ip/cgi-bin/luci/;stok=/api/misystem/block',
      'http://$ip/userRpm/AccessCtrlAccessRulesRpm.htm?mac=$mac&block=1',
    ];

    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = <String, String>{'Content-Type': 'application/json'};
        if (token.contains('=')) headers['Cookie'] = token;
        else headers['Authorization'] = 'Bearer $token';

        final body = jsonEncode({'mac': mac});
        final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 204) return true;
      } catch (_) {}
    }
    return false;
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    // Exemplos de endpoints; provavelmente exigirão payloads específicos.
    final endpoints = [
      'http://$ip/api/limit_client',
      'http://$ip/cgi-bin/luci/;stok=/api/misystem/limit',
    ];

    for (final ep in endpoints) {
      try {
        final uri = Uri.parse(ep);
        final headers = <String, String>{'Content-Type': 'application/json'};
        if (token.contains('=')) headers['Cookie'] = token;
        else headers['Authorization'] = 'Bearer $token';

        final body = jsonEncode({'mac': mac, 'limit_kbps': limit * 1024});
        final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
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

  static List _extractDevicesList(dynamic parsed) {
    // Possíveis formatos:
    // { "data": [...]} or { "result": [...] } or already a list
    if (parsed is List) return parsed;
    if (parsed is Map) {
      if (parsed.containsKey('data') && parsed['data'] is List) return parsed['data'];
      if (parsed.containsKey('result') && parsed['result'] is List) return parsed['result'];
      // alguns endpoints retornam { "clients": [...] }
      if (parsed.containsKey('clients') && parsed['clients'] is List) return parsed['clients'];
      // caso raro: { "devices": [...] }
      if (parsed.containsKey('devices') && parsed['devices'] is List) return parsed['devices'];
    }
    return [];
  }
}
