// /lib/adapters/routers/xiaomi_adapter.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 XiaomiAdapter - Controle de roteadores Xiaomi ┃
// ┃ 🔐 Login, clientes, bloqueio, limite, desbloqueio ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/device_model.dart';
import 'router_adapter.dart';
import 'router_session.dart';
import 'router_type.dart';

class XiaomiAdapter implements RouterAdapter {
  final bool debugMode;
  XiaomiAdapter({this.debugMode = false});

  @override
  Future<RouterSession?> login(String ip, String username, String password) async {
    try {
      final uri = Uri.parse('http://$ip/cgi-bin/luci/rpc/auth');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 6));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is Map && data.containsKey('token')) {
          return RouterSession(
            token: data['token'].toString(),
            type: RouterType.Xiaomi,
          );
        }
      }
    } catch (e) {
      if (debugMode) print('[XiaomiAdapter] login error: $e');
    }
    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    final
