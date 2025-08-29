import 'package:hive/hive.dart';
import 'router_service.dart';
import '../models/device_model.dart';

typedef VoiceCallback = void Function(String msg);

class IANetworkService {
  final VoiceCallback voiceCallback;
  final RouterService routerService;
  List<DeviceModel> devices = [];
  late Box deviceBox;

  IANetworkService({required this.voiceCallback, required this.routerService});

  // Inicializa Hive
  Future<void> initHive() async {
    deviceBox = await Hive.openBox('devicesBox');
  }

  // Atualiza lista de dispositivos e nomes personalizados
  Future<void> updateDevices(String brand, String routerIp) async {
    final fetched = await routerService.fetchConnectedDevices(brand, routerIp);
    devices = fetched.map((d) {
      final name = deviceBox.get(d['mac'], defaultValue: d['name']);
      return DeviceModel(
        ip: d['ip'],
        mac: d['mac'],
        manufacturer: d['manufacturer'],
        type: d['type'],
        name: name,
      );
    }).toList();
  }

  // Analisa tráfego em Mbps e aplica QoS quando necessário
  Future<void> analyzeTraffic(Map<String, double> traffic) async {
    for (var d in devices) {
      double mbps = traffic[d.ip] ?? 0;
      if (mbps > 20 && d.type.contains('TV')) {
        voiceCallback('A TV ${d.name} está consumindo $mbps Mbps. Priorizando jogo...');
        await _prioritizeGameDevice();
      }
    }
  }

  Future<void> _prioritizeGameDevice() async {
    final gameDevice = devices.firstWhere(
      (d) => d.type.contains('Console') || d.type.contains('PC'),
      orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''),
    );

    if (gameDevice.ip != '') {
      voiceCallback('Priorizando ${gameDevice.name}');
      await routerService.prioritizeDevice(gameDevice.ip, gameDevice.mac, priority: 200);
    }
  }

  // Permite renomear dispositivos pelo usuário
  Future<void> renameDevice(String mac, String newName) async {
    deviceBox.put(mac, newName);
    devices = devices.map((d) {
      if (d.mac == mac) d.name = newName;
      return d;
    }).toList();
  }

  // Função para integração completa com roteador
  Future<void> integrateRouter(String brand, String routerIp) async {
    await routerService.configureRouter(brand, routerIp);
    await updateDevices(brand, routerIp);
  }
}
