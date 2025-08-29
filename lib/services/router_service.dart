import '../models/device_model.dart';

class RouterService {
  Map<String, List<DeviceModel>> devicesByRouter = {}; // ip do roteador -> lista de dispositivos
  Map<String, Map<String, double>> trafficByRouter = {}; // ip do roteador -> {mac -> Mbps}

  /// Busca dispositivos reais por marca e IP do roteador
  Future<void> fetchDevices(String brand, String routerIp) async {
    List<DeviceModel> fetchedDevices = [];

    switch (brand.toLowerCase()) {
      case 'tplink':
        fetchedDevices = await _fetchTplink(routerIp);
        break;
      case 'huawei':
        fetchedDevices = await _fetchHuawei(routerIp);
        break;
      case 'xiaomi':
        fetchedDevices = await _fetchXiaomi(routerIp);
        break;
      case 'asus':
        fetchedDevices = await _fetchAsus(routerIp);
        break;
      default:
        fetchedDevices = [];
    }

    devicesByRouter[routerIp] = fetchedDevices;
  }

  /// Obter tráfego real de dispositivos conectados
  Future<Map<String, double>> getTraffic(String routerIp) async {
    Map<String, double> traffic = {};

    // Aqui você implementa a chamada real ao roteador, via API ou scraping
    traffic = trafficByRouter[routerIp] ?? {};

    return traffic;
  }

  /// Prioriza dispositivo via MAC
  Future<void> prioritizeDevice(String mac, {int priority = 100}) async {
    // Implementação real via API do roteador
  }

  /// Atualiza nome/tipo de dispositivo
  void updateDevice(String ip, String mac, {String? name, String? type}) {
    List<DeviceModel>? devs = devicesByRouter[ip];
    if (devs != null) {
      for (var d in devs) {
        if (d.mac == mac) {
          if (name != null) d.name = name;
          if (type != null) d.type = type;
        }
      }
    }
  }

  // ================= Métodos específicos por marca =================

  Future<List<DeviceModel>> _fetchTplink(String routerIp) async {
    // Implementação real para TP-Link
    return [
      DeviceModel(ip: '192.168.0.101', mac: 'AA:BB:CC:DD:EE:01', manufacturer: 'TP-Link', type: 'PC', name: 'Gabinete'),
      DeviceModel(ip: '192.168.0.102', mac: 'AA:BB:CC:DD:EE:02', manufacturer: 'TP-Link', type: 'TV', name: 'Sala')
    ];
  }

  Future<List<DeviceModel>> _fetchHuawei(String routerIp) async {
    // Implementação real para Huawei
    return [
      DeviceModel(ip: '192.168.1.101', mac: 'FF:GG:HH:II:JJ:01', manufacturer: 'Huawei', type: 'Console', name: 'PS5'),
    ];
  }

  Future<List<DeviceModel>> _fetchXiaomi(String routerIp) async {
    // Implementação real para Xiaomi
    return [
      DeviceModel(ip: '192.168.31.101', mac: 'KK:LL:MM:NN:OO:01', manufacturer: 'Xiaomi', type: 'Smartphone', name: 'Celular'),
    ];
  }

  Future<List<DeviceModel>> _fetchAsus(String routerIp) async {
    // Implementação real para Asus
    return [
      DeviceModel(ip: '192.168.50.101', mac: 'PP:QQ:RR:SS:TT:01', manufacturer: 'Asus', type: 'Laptop', name: 'Notebook'),
    ];
  }
}
