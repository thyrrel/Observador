// lib/services/router_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class RouterService {
  // Armazena credenciais padrão em caso de reset
  final Map<String, Map<String, String>> defaultCredentials = {
    'Huawei': {'user': 'admin', 'pass': 'admin'},
    'TPLink': {'user': 'admin', 'pass': 'admin'},
    'Asus': {'user': 'admin', 'pass': 'admin'},
    'Xiaomi': {'user': 'admin', 'pass': 'admin'},
  };

  // Exemplo de lista de roteadores configurados (IP + marca)
  final List<Map<String, String>> routers = [
    {'ip': '192.168.1.1', 'brand': 'Huawei'},
    {'ip': '192.168.0.1', 'brand': 'TPLink'},
    {'ip': '192.168.50.1', 'brand': 'Asus'},
    {'ip': '192.168.31.1', 'brand': 'Xiaomi'},
  ];

  // Obtém dispositivos conectados de um roteador específico
  Future<List<DeviceModel>> getDevices({String? routerIp}) async {
    List<DeviceModel> devices = [];
    for (var router in routers) {
      if (routerIp != null && router['ip'] != routerIp) continue;
      List<DeviceModel> routerDevices = await _fetchDevices(router);
      devices.addAll(routerDevices);
    }
    return devices;
  }

  Future<List<DeviceModel>> _fetchDevices(Map<String, String> router) async {
    String ip = router['ip']!;
    String brand = router['brand']!;
    Map<String, String> creds = defaultCredentials[brand]!;

    // Aqui cada marca pode ter API/endpoint diferente
    try {
      switch (brand) {
        case 'Huawei':
          return await _fetchHuawei(ip, creds['user']!, creds['pass']!);
        case 'TPLink':
          return await _fetchTPLink(ip, creds['user']!, creds['pass']!);
        case 'Asus':
          return await _fetchAsus(ip, creds['user']!, creds['pass']!);
        case 'Xiaomi':
          return await _fetchXiaomi(ip, creds['user']!, creds['pass']!);
        default:
          return [];
      }
    } catch (e) {
      print('Erro ao obter dispositivos do $brand: $e');
      return [];
    }
  }

  // Métodos específicos de cada marca (tráfego real)
  Future<List<DeviceModel>> _fetchHuawei(String ip, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/api/devices'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    return _parseDevices(response.body);
  }

  Future<List<DeviceModel>> _fetchTPLink(String ip, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/device_list'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    return _parseDevices(response.body);
  }

  Future<List<DeviceModel>> _fetchAsus(String ip, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/api/clients'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    return _parseDevices(response.body);
  }

  Future<List<DeviceModel>> _fetchXiaomi(String ip, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/lan/host'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    return _parseDevices(response.body);
  }

  // Parse genérico para todos
  List<DeviceModel> _parseDevices(String body) {
    var data = jsonDecode(body);
    List<DeviceModel> devices = [];
    for (var d in data['devices']) {
      devices.add(DeviceModel(
        ip: d['ip'],
        mac: d['mac'],
        manufacturer: d['manufacturer'] ?? 'Desconhecido',
        type: d['type'] ?? 'Desconhecido',
        name: d['name'] ?? d['mac'],
      ));
    }
    return devices;
  }

  // Tráfego real por dispositivo
  Future<double> getDeviceTraffic(String mac) async {
    // Para simplificar: varrer todos roteadores e encontrar o dispositivo
    for (var router in routers) {
      try {
        // Cada marca pode ter endpoint de tráfego diferente
        String ip = router['ip']!;
        String brand = router['brand']!;
        Map<String, String> creds = defaultCredentials[brand]!;
        switch (brand) {
          case 'Huawei':
            return await _getHuaweiTraffic(ip, mac, creds['user']!, creds['pass']!);
          case 'TPLink':
            return await _getTPLinkTraffic(ip, mac, creds['user']!, creds['pass']!);
          case 'Asus':
            return await _getAsusTraffic(ip, mac, creds['user']!, creds['pass']!);
          case 'Xiaomi':
            return await _getXiaomiTraffic(ip, mac, creds['user']!, creds['pass']!);
        }
      } catch (_) {}
    }
    return 0.0;
  }

  Future<double> _getHuaweiTraffic(String ip, String mac, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/api/traffic?mac=$mac'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    var data = jsonDecode(response.body);
    return (data['mbps'] ?? 0).toDouble();
  }

  Future<double> _getTPLinkTraffic(String ip, String mac, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/traffic?mac=$mac'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    var data = jsonDecode(response.body);
    return (data['mbps'] ?? 0).toDouble();
  }

  Future<double> _getAsusTraffic(String ip, String mac, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/api/traffic?mac=$mac'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    var data = jsonDecode(response.body);
    return (data['mbps'] ?? 0).toDouble();
  }

  Future<double> _getXiaomiTraffic(String ip, String mac, String user, String pass) async {
    var response = await http.get(Uri.parse('http://$ip/lan/traffic?mac=$mac'), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
    });
    var data = jsonDecode(response.body);
    return (data['mbps'] ?? 0).toDouble();
  }

  // Bloquear dispositivo
  Future<void> blockDevice(String mac) async {
    for (var router in routers) {
      String ip = router['ip']!;
      String brand = router['brand']!;
      Map<String, String> creds = defaultCredentials[brand]!;
      await http.post(Uri.parse('http://$ip/block_device'), headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${creds['user']}:${creds['pass']}'))}'
      }, body: {'mac': mac});
    }
  }

  // Limitar dispositivo
  Future<void> limitDevice(String mac, double mbps) async {
    for (var router in routers) {
      String ip = router['ip']!;
      String brand = router['brand']!;
      Map<String, String> creds = defaultCredentials[brand]!;
      await http.post(Uri.parse('http://$ip/limit_device'), headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${creds['user']}:${creds['pass']}'))}'
      }, body: {'mac': mac, 'limit': mbps.toString()});
    }
  }

  // Priorizar dispositivo
  Future<void> prioritizeDevice(String mac, {int priority = 100}) async {
    for (var router in routers) {
      String ip = router['ip']!;
      String brand = router['brand']!;
      Map<String, String> creds = defaultCredentials[brand]!;
      await http.post(Uri.parse('http://$ip/prioritize_device'), headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${creds['user']}:${creds['pass']}'))}'
      }, body: {'mac': mac, 'priority': priority.toString()});
    }
  }
}

// Modelo simplificado para integração
class DeviceModel {
  final String ip;
  final String mac;
  final String manufacturer;
  final String type;
  final String name;

  DeviceModel({
    required this.ip,
    required this.mac,
    required this.manufacturer,
    required this.type,
    required this.name,
  });
}
