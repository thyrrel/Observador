// router_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device_model.dart';

class RouterService {
  final Map<String, Map<String, String>> defaultCredentials = {
    'TP-Link': {'user': 'admin', 'pass': 'admin'},
    'Xiaomi': {'user': 'admin', 'pass': 'admin'},
    'Huawei': {'user': 'admin', 'pass': 'admin'},
    'Asus': {'user': 'admin', 'pass': 'admin'},
  };

  /// Lista de dispositivos conectados por roteador
  Map<String, List<DeviceModel>> devicesByRouter = {};

  /// Conecta automaticamente ao roteador pelo IP e marca os dispositivos
  Future<bool> connect(String routerBrand, String ip,
      {String? user, String? pass}) async {
    final creds = {
      'user': user ?? defaultCredentials[routerBrand]?['user'],
      'pass': pass ?? defaultCredentials[routerBrand]?['pass']
    };
    if (creds['user'] == null || creds['pass'] == null) return false;

    try {
      // Exemplo de login para roteador (cada marca tem API própria)
      final response = await http.post(
        Uri.parse('http://$ip/login'),
        body: jsonEncode({'username': creds['user'], 'password': creds['pass']}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Ao conectar, busca lista de dispositivos
        await fetchDevices(routerBrand, ip);
        return true;
      }
    } catch (e) {
      print('Erro ao conectar $routerBrand $ip: $e');
    }
    return false;
  }

  /// Obtém a lista de dispositivos conectados (tráfego real)
  Future<void> fetchDevices(String routerBrand, String ip) async {
    try {
      final response = await http.get(Uri.parse('http://$ip/devices'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        devicesByRouter[ip] = data
            .map((d) => DeviceModel.fromMap(Map<String, dynamic>.from(d)))
            .toList();
      }
    } catch (e) {
      print('Erro ao buscar dispositivos $routerBrand $ip: $e');
    }
  }

  /// Prioriza dispositivo por MAC (QoS real)
  Future<void> prioritizeDevice(String mac,
      {int priority = 100, String? routerIp}) async {
    try {
      String? ip = routerIp ??
          devicesByRouter.keys.firstWhere(
              (k) => devicesByRouter[k]!.any((d) => d.mac == mac),
              orElse: () => '');
      if (ip.isEmpty) return;

      final response = await http.post(
        Uri.parse('http://$ip/qos'),
        body: jsonEncode({'mac': mac, 'priority': priority}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Dispositivo $mac priorizado com $priority Mbps');
      }
    } catch (e) {
      print('Erro ao priorizar dispositivo $mac: $e');
    }
  }

  /// Atualiza nome ou tipo do dispositivo
  void updateDevice(String ip, String mac, {String? name, String? type}) {
    final routerDevices = devicesByRouter[ip];
    if (routerDevices != null) {
      final device = routerDevices.firstWhere(
          (d) => d.mac == mac,
          orElse: () => DeviceModel(
              ip: ip, mac: mac, manufacturer: 'Desconhecido', type: '', name: ''));
      if (device.ip != '') {
        if (name != null) device.name = name;
        if (type != null) device.type = type;
      }
    }
  }

  /// Método geral de tráfego real: retorna Mbps por dispositivo
  Future<Map<String, double>> getTraffic(String routerIp) async {
    Map<String, double> usage = {};
    try {
      final response = await http.get(Uri.parse('http://$routerIp/traffic'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        for (var d in data) {
          String mac = d['mac'];
          double mbps = (d['mbps'] ?? 0).toDouble();
          usage[mac] = mbps;
        }
      }
    } catch (e) {
      print('Erro ao obter tráfego $routerIp: $e');
    }
    return usage;
  }
}
