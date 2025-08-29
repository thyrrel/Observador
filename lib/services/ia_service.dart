// ia_service.dart
import '../models/device_model.dart';
import 'router_service.dart';

typedef VoiceCallback = void Function(String msg);

class IAService {
  final VoiceCallback voiceCallback;
  final RouterService routerService;
  List<DeviceModel> devices = [];

  IAService({required this.voiceCallback, required this.routerService});

  // Atualiza dispositivos e identifica tipos suspeitos
  Future<void> analyzeDevices(List<DeviceModel> devs) async {
    devices = devs;
    for (var d in devices) {
      if (d.type.contains('Desconhecido')) {
        voiceCallback('Dispositivo suspeito detectado: ${d.name}');
      }
    }
    // Aplicar otimização automática via RouterService
    await routerService.autoOptimize(devices.map((d) => d.toMap()).toList());
  }

  // Analisa tráfego em tempo real
  Future<void> analyzeTraffic(Map<String, double> usage) async {
    for (var d in devices) {
      double mbps = usage[d.ip] ?? 0;
      if (mbps > 20 && d.type.contains('TV')) {
        voiceCallback('A TV ${d.name} está consumindo $mbps Mbps. Deseja priorizar o jogo?');
        await _suggestQoS(d);
      }
    }
  }

  // Sugere priorização para dispositivos de jogos
  Future<void> _suggestQoS(DeviceModel tv) async {
    DeviceModel? gameDevice = devices.firstWhere(
      (d) => d.type.contains('Console') || d.type.contains('PC'),
      orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: '')
    );

    if (gameDevice.ip != '') {
      voiceCallback('Sugerindo priorizar ${gameDevice.name}');
      await routerService.prioritizeDevice(gameDevice.mac, priority: 200);
    }
  }
}
