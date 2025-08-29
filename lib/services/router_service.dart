import 'dart:convert';
import 'package:http/http.dart' as http;

class RouterService {
  // Credenciais padrão por marca
  final Map<String, Map<String, String>> defaultCredentials = {
    'Huawei': {'user': 'admin', 'pass': 'admin'},
    'TPLink': {'user': 'admin', 'pass': 'admin'},
    'Xiaomi': {'user': 'admin', 'pass': 'admin'},
    'Asus': {'user': 'admin', 'pass': 'admin'},
  };

  // Função para login automático
  Future<bool> login(String brand, String ip,
      {String? username, String? password}) async {
    final creds = defaultCredentials[brand]!;
    final user = username ?? creds['user']!;
    final pass = password ?? creds['pass']!;
    try {
      // Exemplo de requisição de login genérico
      final response = await http.post(
        Uri.parse('http://$ip/login'),
        body: {'username': user, 'password': pass},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Função para priorizar dispositivo via MAC
  Future<bool> prioritizeDevice(String ip, String mac,
      {int priority = 100}) async {
    try {
      final response = await http.post(
        Uri.parse('http://$ip/qos/prioritize'),
        body: jsonEncode({'mac': mac, 'priority': priority}),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Função para obter lista de dispositivos conectados
  Future<List<Map<String, dynamic>>> fetchConnectedDevices(
      String brand, String ip) async {
    try {
      final response = await http.get(Uri.parse('http://$ip/devices'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Função para aplicar configuração completa em um roteador
  Future<void> configureRouter(String brand, String ip,
      {String? username, String? password}) async {
    final loggedIn = await login(brand, ip, username: username, password: password);
    if (!loggedIn) return;

    final devices = await fetchConnectedDevices(brand, ip);
    for (var device in devices) {
      if (device['type'] == 'Console' || device['type'] == 'PC') {
        await prioritizeDevice(ip, device['mac'], priority: 200);
      }
    }
  }
}
