import 'dart:convert';
import 'package:http/http.dart' as http;

class RouterService {
  // Lista de roteadores suportados e credenciais padrão
  final Map<String, Map<String, String>> routers = {
    'Huawei': {'ip': '192.168.3.1', 'user': 'admin', 'pass': 'admin'},
    'TPLink': {'ip': '192.168.0.1', 'user': 'admin', 'pass': 'admin'},
    'Xiaomi': {'ip': '192.168.31.1', 'user': 'admin', 'pass': 'admin'},
    'Asus': {'ip': '192.168.1.1', 'user': 'admin', 'pass': 'admin'},
  };

  Future<bool> login(String brand) async {
    if (!routers.containsKey(brand)) return false;
    final router = routers[brand]!;
    try {
      // Exemplo de login genérico (ajustar conforme API de cada marca)
      final response = await http.post(
        Uri.parse('http://${router['ip']}/login'),
        body: jsonEncode({'username': router['user'], 'password': router['pass']}),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> prioritizeDevice(String mac, {int priority = 100}) async {
    for (var brand in routers.keys) {
      if (!await login(brand)) continue;
      final router = routers[brand]!;
      try {
        // Exemplo de configuração de QoS genérico
        final response = await http.post(
          Uri.parse('http://${router['ip']}/qos'),
          body: jsonEncode({'mac': mac, 'priority': priority}),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) return true;
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  Future<bool> rebootRouter(String brand) async {
    if (!routers.containsKey(brand)) return false;
    if (!await login(brand)) return false;
    final router = routers[brand]!;
    try {
      final response = await http.post(
        Uri.parse('http://${router['ip']}/reboot'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e
