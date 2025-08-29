// [Flutter] lib/adapters/mikrotik_adapter.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';

class MikrotikAdapter implements RouterAdapter {
  MikrotikAdapter();

  @override
  Future<String?> login(String ip, String username, String password) async {
    final basic = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final headers = {'Authorization': basic, 'Accept': 'application/json'};

    // 1) REST raiz
    try {
      final uri = Uri.parse('http://$ip/rest/');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 401) return basic;
    } catch (e) {
      print('Mikrotik login REST root exception: $e');
    }

    // 2) REST /system/resource
    try {
      final uri = Uri.parse('http://$ip/rest/system/resource');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) return basic;
    } catch (e) {
      print('Mikrotik login REST system exception: $e');
    }

    // 3) Basic GET fallback raiz
    try {
      final uri = Uri.parse('http://$ip/');
      final resp = await http.get(uri, headers: {'Authorization': basic}).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) return basic;
    } catch (e) {
      print('Mikrotik login fallback exception: $e');
    }

    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String? token) async {
    final List<RouterDevice> devices = [];
    if (token == null) return devices;

    final headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // DHCP leases
    try {
      final uri = Uri.parse('http://$ip/rest/ip/dhcp-server/lease');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is List && parsed.isNotEmpty) {
          for (var item in parsed) {
            final mac = (item['mac-address'] ?? item['mac'] ?? '').toString();
            final ipAddr = (item['address'] ?? '').toString();
            final host = (item['host-name'] ?? item['comment'] ?? '').toString();
            devices.add(RouterDevice(
              mac: mac,
              name: host.isEmpty ? ipAddr : host,
              rxBytes: 0,
              txBytes: 0,
              blocked: false,
            ));
          }
          if (devices.isNotEmpty) return devices;
        }
      }
    } catch (e) {
      print('Mikrotik getClients DHCP exception: $e');
    }

    // Wireless registrations
    try {
      final uri = Uri.parse('http://$ip/rest/interface/wireless/registration-table');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is List && parsed.isNotEmpty) {
          for (var item in parsed) {
            final mac = (item['mac-address'] ?? item['mac'] ?? '').toString();
            final host = (item['radio-name'] ?? item['host-name'] ?? '').toString();
            devices.add(RouterDevice(
              mac: mac,
              name: host.isEmpty ? mac : host,
              rxBytes: _toInt(item['rx-byte']),
              txBytes: _toInt(item['tx-byte']),
              blocked: false,
            ));
          }
          if (devices.isNotEmpty) return devices;
        }
      }
    } catch (e) {
      print('Mikrotik getClients Wireless exception: $e');
    }

    // Fallback ARP
    try {
      final uri = Uri.parse('http://$ip/rest/ip/arp');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
        if (parsed is List) {
          for (var item in parsed) {
            final mac = (item['mac-address'] ?? item['mac'] ?? '').toString();
            final ipAddr = (item['address'] ?? '').toString();
            devices.add(RouterDevice(mac: mac, name: ipAddr, rxBytes: 0, txBytes: 0, blocked: false));
          }
          if (devices.isNotEmpty) return devices;
        }
      }
    } catch (e) {
      print('Mikrotik getClients ARP exception: $e');
    }

    // HTML fallback
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
    } catch (e) {
      print('Mikrotik getClients HTML fallback exception: $e');
    }

    return devices;
  }

  @override
  Future<bool> blockDevice(String ip, String? token, String mac) async {
    if (token == null) return false;
    final headers = {'Authorization': token, 'Accept': 'application/json', 'Content-Type': 'application/json'};
    String? ipOfMac;

    // Obter IP via ARP
    try {
      final uri = Uri.parse('http://$ip/rest/ip/arp');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
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
    } catch (e) {
      print('Mikrotik blockDevice ARP exception: $e');
    }

    if (ipOfMac != null && ipOfMac.isNotEmpty) {
      try {
        final uri = Uri.parse('http://$ip/rest/ip/firewall/address-list');
        final body = jsonEncode({'list': 'blocked-by-observador', 'address': ipOfMac, 'comment': 'blocked'});
        final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
        if (resp.statusCode == 200 || resp.statusCode == 201) return true;
      } catch (_) {}
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
        if (resp.statusCode == 200 || resp.statusCode == 201) return true;
      } catch (_) {}
    }

    return false;
  }

  @override
  Future<bool> limitDevice(String ip, String? token, String mac, int limit) async {
    if (token == null) return false;
    final headers = {'Authorization': token, 'Accept': 'application/json', 'Content-Type': 'application/json'};
    String? ipOfMac;

    try {
      final uri = Uri.parse('http://$ip/rest/ip/arp');
      final resp = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final parsed = jsonDecode(resp.body);
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

    try {
      final uri = Uri.parse('http://$ip/rest/queue/simple');
      final body = jsonEncode({
        'name': 'obs-${mac.replaceAll(':', '')}',
        'target': ipOfMac,
        'max-limit': '${limit}k/${limit}k'
      });
      final resp = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200 || resp.statusCode == 201) return true;
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
    final set = <String>{};
    for (var m in matches) {
      set.add(m.group(0) ?? '');
    }
    return set.toList();
  }
}
