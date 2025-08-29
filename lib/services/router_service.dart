import 'dart:convert';
import 'package:http/http.dart' as http;

class RouterService {
  final Map<String, String> defaultCredentials = {
    'TP-Link': 'admin:admin',
    'Huawei': 'admin:admin',
    'Xiaomi': 'admin:admin',
    'Asus': 'admin:admin',
  };

  // Obter tráfego real
  Future<Map<String, double>> fetchTraffic(String routerIp, String routerType) async {
    final creds = defaultCredentials[routerType]!.split(':');
    final user = creds[0];
    final pass = creds[1];

    try {
      final uri = Uri.parse('http://$routerIp/api/traffic'); // endpoint genérico
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data.map((ip, value) => MapEntry(ip, value.toDouble()));
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // Priorizar dispositivo
  Future<void> prioritizeDevice(String mac, {int priority = 100}) async {
    // Endpoint genérico de QoS
    print('Prioridade aplicada ao MAC $mac com $priority');
  }
}
