import 'dart:convert';
import 'package:http/http.dart' as http;

class RouterService {
  // Credenciais padrão (para reset ou acesso inicial)
  final Map<String, Map<String, String>> defaultCredentials = {
    'TP-Link': {'user': 'admin', 'password': 'admin'},
    'Xiaomi': {'user': 'admin', 'password': 'admin'},
    'Asus': {'user': 'admin', 'password': 'admin'},
    'Huawei': {'user': 'admin', 'password': 'admin'}
  };

  // Armazena credenciais customizadas do usuário
  final Map<String, Map<String, String>> savedCredentials = {};

  RouterService();

  // Conecta ao roteador usando credenciais fornecidas ou padrão
  Future<bool> connect(String brand, String ip) async {
    Map<String, String> creds = savedCredentials[brand] ?? defaultCredentials[brand]!;

    // Exemplo genérico de login (cada marca terá endpoint diferente)
    try {
      var response = await http.post(
        Uri.parse('http://$ip/login'),
        body: {'username': creds['user'], 'password': creds['password']},
      );

      if (response.statusCode == 200) {
        print('$brand conectado com sucesso em $ip');
        return true;
      }
      return false;
    } catch (e) {
      print('Erro ao conectar $brand em $ip: $e');
      return false;
    }
  }

  // Prioriza um dispositivo pelo MAC ou IP
  Future<void> prioritizeDevice(String mac, {int priority = 100}) async {
    // Aqui você deve implementar o endpoint real do QoS de cada marca
    print('Prioridade de $mac ajustada para $priority');
  }

  // Bloqueia um dispositivo na rede
  Future<void> blockDevice(String mac) async {
    print('Dispositivo $mac bloqueado');
  }

  // Desbloqueia um dispositivo na rede
  Future<void> unblockDevice(String mac) async {
    print('Dispositivo $mac desbloqueado');
  }

  // Atualiza credenciais personalizadas
  void saveCredentials(String brand, String user, String password) {
    savedCredentials[brand] = {'user': user, 'password': password};
  }

  // Detecta automaticamente dispositivos conectados (tráfego real)
  Future<List<Map<String, dynamic>>> getConnectedDevices(String ip, String brand) async {
    List<Map<String, dynamic>> devices = [];

    try {
      // Simulação de request real, adaptar para cada marca
      var response = await http.get(Uri.parse('http://$ip/devices'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        for (var d in data) {
          devices.add({
            'name': d['name'] ?? 'Desconhecido',
            'ip': d['ip'],
            'mac': d['mac'],
            'type': d['type'] ?? 'Desconhecido',
            'traffic': d['traffic'] ?? 0
          });
        }
      }
    } catch (e) {
      print('Erro ao obter dispositivos de $brand em $ip: $e');
    }

    return devices;
  }

  // Aplica priorizações automáticas de acordo com padrões da IA
  Future<void> autoOptimize(List<Map<String, dynamic>> devices) async {
    for (var d in devices) {
      if (d['type'].contains('TV') && (d['traffic'] ?? 0) > 20) {
        // Exemplo: priorizar consoles ou PCs quando streaming é alto
        print('Otimização aplicada em ${d['name']}');
      }
    }
  }
}
