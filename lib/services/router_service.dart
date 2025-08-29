import 'package:http/http.dart' as http;
import '../models/device_model.dart';

class RouterService {
  Map<String, String> defaultCredentials = {
    'tplink': 'admin:admin',
    'huawei': 'admin:admin',
    'xiaomi': 'admin:admin',
    'asus': 'admin:admin',
  };

  List<DeviceModel> connectedDevices = [];

  /// Conecta a um roteador pelo tipo e IP, usando credenciais padrão
  Future<void> connectRouter(String brand, String ip,
      {String? username, String? password}) async {
    final creds = (username != null && password != null)
        ? '$username:$password'
        : defaultCredentials[brand]!;
    // Teste de login HTTP básico (simplificado)
    final uri = Uri.parse('http://$ip/login');
    try {
      final response = await http.post(uri, body: {'user': creds.split(':')[0], 'pass': creds.split(':')[1]});
      if (response.statusCode == 200) {
        print('Conectado ao $brand em $ip');
      } else {
        print('Falha ao conectar $brand em $ip');
      }
    } catch (e) {
      print('Erro conexão $brand: $e');
    }
  }

  /// Obtém a lista de dispositivos conectados do roteador
  Future<List<DeviceModel>> fetchConnectedDevices(String brand, String ip) async {
    // Aqui você implementa o parsing real do JSON/HTML do roteador
    // Para cada marca, o método é específico (ex: TP-Link API, Huawei API, etc.)
    // Exemplo genérico:
    connectedDevices = [
      DeviceModel(ip: '192.168.0.10', mac: 'AA:BB:CC:DD:EE:01', manufacturer: brand, type: 'PC', name: 'Computador Sala'),
      DeviceModel(ip: '192.168.0.11', mac: 'AA:BB:CC:DD:EE:02', manufacturer: brand, type: 'TV', name: 'Smart TV')
    ];
    return connectedDevices;
  }

  /// Prioriza um dispositivo no roteador
  Future<void> prioritizeDevice(String mac, {int priority = 100}) async {
    // Enviar comando de QoS real
    print('Dispositivo $mac priorizado com peso $priority Mbps');
    // Aqui você chamaria o endpoint específico de QoS de cada roteador
  }

  /// Permite renomear dispositivo na lista local
  void renameDevice(String mac, String newName) {
    final device = connectedDevices.firstWhere((d) => d.mac == mac, orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));
    if (device.mac != '') device.name = newName;
  }

  /// Função de integração completa para um roteador
  Future<void> integrateRouter(String brand, String ip,
      {String? username, String? password}) async {
    await connectRouter(brand, ip, username: username, password: password);
    await fetchConnectedDevices(brand, ip);
    print('Integração completa do $brand em $ip concluída.');
  }
}
