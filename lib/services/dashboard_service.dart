// dashboard_service.dart
import '../models/device_model.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';

class DashboardService {
  final RouterService routerService;
  final IAService iaService;
  List<DeviceModel> devices = [];

  DashboardService({required this.routerService, required this.iaService});

  // Atualiza dispositivos conectados no dashboard
  Future<void> updateDevices(String routerBrand, String routerIP) async {
    var devs = await routerService.getConnectedDevices(routerIP, routerBrand);
    devices = devs.map((d) => DeviceModel(
      ip: d['ip'],
      mac: d['mac'],
      name: d['name'],
      type: d['type'],
      manufacturer: d['manufacturer'] ?? 'Desconhecido'
    )).toList();

    // Notifica IA para análise
    await iaService.analyzeDevices(devices);
  }

  // Atualiza tráfego em tempo real no dashboard
  Future<void> updateTraffic(Map<String, double> usage) async {
    await iaService.analyzeTraffic(usage);
  }

  // Permite renomear dispositivo
  void renameDevice(String mac, String newName) {
    var device = devices.firstWhere((d) => d.mac == mac, orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));
    if (device.mac != '') {
      device.name = newName;
    }
  }
}
