import '../models/device_model.dart';
import 'router_service.dart';

typedef VoiceCallback = void Function(String msg);

class IAService {
  final VoiceCallback voiceCallback;
  final RouterService routerService;
  List<DeviceModel> devices = [];

  IAService({required this.voiceCallback, required this.routerService});

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
      double mbps = usage[d.ip] ?? 0;
      if (mbps > 20 && d.type.contains('TV')) {
        voiceCallback('A TV ${d.name} está consumindo $mbps Mbps. Deseja priorizar o jogo?');
        _suggestQoS(d);
      }
    }
  }

  void _suggestQoS(DeviceModel tv) {
    DeviceModel? gameDevice = devices.firstWhere(
        (d) => d.type.contains('Console') || d.type.contains('PC'),
        orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));

    if (gameDevice.ip != '') {
      voiceCallback('Sugerindo priorizar ${gameDevice.name}');
      routerService.prioritizeDevice(gameDevice.mac, priority: 200);
    }
  }
}
