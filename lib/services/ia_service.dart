import '../models/device_model.dart';
import 'router_service.dart';

typedef VoiceCallback = void Function(String msg);

class IAService {
  final VoiceCallback voiceCallback;
  final RouterService routerService;
  List<DeviceModel> devices = [];

  IAService({required this.voiceCallback, required this.routerService});

  /// Atualiza dispositivos conectados e realiza análise
  Future<void> updateAndAnalyze(String routerIp) async {
    // Buscar dispositivos reais
    await routerService.fetchDevices('TP-Link', routerIp); // Pode parametrizar marca
    devices = routerService.devicesByRouter[routerIp] ?? [];

    // Buscar tráfego real
    Map<String, double> traffic = await routerService.getTraffic(routerIp);

    // Analisar dispositivos
    analyzeDevices(devices);

    // Analisar tráfego e sugerir QoS
    analyzeTraffic(devices, traffic);
  }

  void analyzeDevices(List<DeviceModel> devs) {
    devices = devs;
    for (var d in devices) {
      if (d.type.contains('Desconhecido')) {
        voiceCallback('Dispositivo suspeito detectado: ${d.name}');
      }
    }
  }

  void analyzeTraffic(List<DeviceModel> devs, Map<String, double> usage) {
    for (var d in devs) {
      double mbps = usage[d.mac] ?? 0;
      if (mbps > 20 && d.type.contains('TV')) {
        voiceCallback(
            'A TV ${d.name} está consumindo $mbps Mbps. Deseja priorizar o jogo?');
        _suggestQoS(d, usage);
      }
    }
  }

  void _suggestQoS(DeviceModel tv, Map<String, double> usage) {
    DeviceModel? gameDevice = devices.firstWhere(
        (d) => d.type.contains('Console') || d.type.contains('PC'),
        orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));

    if (gameDevice.ip != '') {
      voiceCallback('Sugerindo priorizar ${gameDevice.name}');
      routerService.prioritizeDevice(gameDevice.mac, priority: 200);
    }
  }

  /// Permite atualizar nome e tipo do dispositivo
  void editDevice(String ip, String mac, {String? name, String? type}) {
    routerService.updateDevice(ip, mac, name: name, type: type);
    // Atualiza lista local
    devices = routerService.devicesByRouter[ip] ?? devices;
  }
}
