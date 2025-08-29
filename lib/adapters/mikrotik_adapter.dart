// [Flutter] lib/adapters/mikrotik_adapter.dart
// Adaptador MikroTik (RouterOS) para uso com RouterAdapter
// Tenta REST API (/rest) com Basic Auth e faz parsing de endpoints comuns.
// Ajuste endpoints/payloads se necessário para sua versão do RouterOS.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';

class MikrotikAdapter implements RouterAdapter {
  MikrotikAdapter();

  /// Tenta autenticar usando REST endpoints com Basic Auth.
  /// Retorna um "token" abstrato: aqui usaremos o header Authorization (Basic) como token.
  @override
  Future<String?> login(String ip, String username, String password) async {
    try {
      final uri = Uri.parse('http://$ip/rest/');
      final basic = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      final resp = await http.get(uri, headers: {
        'Authorization': basic,
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 6));

      // Se rest está habilitado, endpoint raiz pode retornar 200
      if (resp.statusCode == 200 || resp.statusCode == 401) {
        // Mesmo se 401, devolvemos Basic para ser usado nas chamadas (pode ser necessário)
        return basic;
      }
    } catch (_) {}

    // Fallback: tentar endpoint /rest/system/resource
    try {
      final uri = Uri.parse('http://$ip/rest/system/resource');
      final basic = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final resp = await http.get(uri, headers: {
        'Authorization': basic,
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) return basic;
    } catch (_) {}

    // Fallback final: tentar Basic GET na raiz
    try {
      final uri = Uri.parse('http://$ip/');
      final basic = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final resp = await http.get(uri, headers: {'Authorization': basic}).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) return basic;
    } catch (_) {}

    return null;
  }

  /// Obtém clientes conectados: tenta REST /ip/dhcp-server/lease e /interface/wireless/registration-table
  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final List<RouterDevice> devices = [];
    if (token == null) return devices;

    final headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // 1) DHCP leases (IPs e MACs)
    try {
      final uri = Uri.parse('http://$ip/rest/ip/dhcp-server/lease');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is List && parsed.isNotEmpty) {
          for (var item in parsed) {
            final mac = (item['mac-address'] ?? item['mac-address'] ?? item['mac'] ?? '').toString();
            final ipAddr = (item['address'] ?? '').toString();
            final host = (item['host-name'] ?? item['comment'] ?? '').toString();
            // rx/tx não disponíveis diretamente aqui; deixamos 0 (pode ser obtido via /interface/traffic-monitor ou flows)
            devices.add(RouterDevice(mac: mac, name: host.isEmpty ? ipAddr : host, rxBytes: 0, txBytes: 0, blocked: false));
          }
          if (devices.isNotEmpty) return devices;
        }
      }
    } catch (_) {}

    // 2) Wireless registrations (se for AP)
    try {
      final uri = Uri.parse('http://$ip/rest/interface/wireless/registration-table');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is List && parsed.isNotEmpty) {
          for (var item in parsed) {
            final mac = (item['mac-address'] ?? item['mac'] ?? '').toString();
            final host = (item['radio-name'] ?? item['host-name'] ?? '').toString();
            final rx = _toInt(item['rx-byte']);
            final tx = _toInt(item['tx-byte']);
            devices.add(RouterDevice(mac: mac, name: host.isEmpty ? mac : host, rxBytes: rx, txBytes: tx, blocked: false));
          }
          if (devices.isNotEmpty) return devices;
        }
      }
    } catch (_) {}

    // 3) Fallback: tentar parsing de /rest/ip/arp para encontrar MACs
    try {
      final uri = Uri.parse('http://$ip/rest/ip/arp');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is List && parsed.isNotEmpty) {
          for (var item in parsed) {
            final mac = (item['mac-address'] ?? item['mac'] ?? '').toString();
            final ipAddr = (item['address'] ?? '').toString();
            devices.add(RouterDevice(mac: mac, name: ipAddr, rxBytes: 0, txBytes: 0, blocked: false));
          }
          if (devices.isNotEmpty) return devices;
        }
      }
    } catch (_) {}

    // 4) Se nada encontrado via REST, tentar scraping simples do HTML (caso WebGUI exponha tabela)
    try {
      final uri = Uri.parse('http://$ip/');
      final resp = await http.get(uri, headers: {'Authorization': token}).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final list = _parseMacsFromHtml(resp.body);
        for (var mac in list) {
          devices.add(RouterDevice(mac: mac, name: 'Desconhecido', rxBytes: 0, txBytes: 0, blocked: false));
        }
        if (devices.isNotEmpty) return devices;
      }
    } catch (_) {}

    // Retorna lista (pode estar vazia se roteador não expôs dados via REST)
    return devices;
  }

  /// Bloqueia dispositivo: cria entrada em address-list e regra de firewall via REST (tentativa genérica)
  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    if (token == null) return false;
    final headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // 1) Adicionar mac/ip à address-list (precisa converter MAC->IP; tentamos obter IP via arp)
    String? ipOfMac;
    try {
      final arpUri = Uri.parse('http://$ip/rest/ip/arp');
      final arpResp = await http.get(arpUri, headers: headers).timeout(const Duration(seconds: 6));
      if (arpResp.statusCode == 200) {
        final parsed = jsonDecode(arpResp.body);
        if (parsed is List) {
          for (var entry in parsed) {
            final macAddr = (entry['mac-address'] ?? '').toString().toLowerCase();
            if (macAddr == mac.toLowerCase()) {
              ipOfMac = (entry['address'] ?? '').toString();
              break;
            }
          }
        }
      }
    } catch (_) {}

    // Se encontramos IP, tentar criar uma regra de firewall para bloquear esse IP
    if (ipOfMac != null && ipOfMac.isNotEmpty) {
      try {
        final uri = Uri.parse('http://$ip/rest/ip/firewall/address-list');
        final body = jsonEncode({'list': 'blocked-by-observador', 'address': ipOfMac, 'comment': 'blocked'});
        final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 201 || resp.statusCode == 200) return true;
      } catch (_) {}
    }

    // 2) Alternativa: adicionar firewall rule (mais agressivo) - tentativa genérica
    try {
      final uri = Uri.parse('http://$ip/rest/ip/firewall/filter');
      final body = jsonEncode({
        'chain': 'forward',
        'src-address-list': 'blocked-by-observador',
        'action': 'drop',
        'disabled': false,
        'comment': 'blocked-by-observador'
      });
      final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 201 || resp.statusCode == 200) return true;
    } catch (_) {}

    // 3) Se não foi possível, retornar false
    return false;
  }

  /// Limita dispositivo (cria simple queue). Retorna true se criou.
  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    if (token == null) return false;
    final headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Primeiro, tentar obter IP do MAC via ARP
    String? ipOfMac;
    try {
      final arpUri = Uri.parse('http://$ip/rest/ip/arp');
      final arpResp = await http.get(arpUri, headers: headers).timeout(const Duration(seconds: 6));
      if (arpResp.statusCode == 200) {
        final parsed = jsonDecode(arpResp.body);
        if (parsed is List) {
          for (var entry in parsed) {
            final macAddr = (entry['mac-address'] ?? '').toString().toLowerCase();
            if (macAddr == mac.toLowerCase()) {
              ipOfMac = (entry['address'] ?? '').toString();
              break;
            }
          }
        }
      }
    } catch (_) {}

    if (ipOfMac == null) return false;

    // Criar simple-queue limitando em kbps
    try {
      final uri = Uri.parse('http://$ip/rest/queue/simple');
      final body = jsonEncode({
        'name': 'obs-${mac.replaceAll(':', '')}',
        'target': ipOfMac,
        'max-limit': '${limit}k/${limit}k' // formato "rxk/txk" simplificado
      });
      final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 201 || resp.statusCode == 200) return true;
    } catch (_) {}

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

  static List<String> _parseMacsFromHtml(String html) {
    final macRegex = RegExp(r'([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})');
    final matches = macRegex.allMatches(html);
    final list = <String>{};
    for (var m in matches) {
      list.add(m.group(0) ?? '');
    }
    return list.toList();
  }
}
