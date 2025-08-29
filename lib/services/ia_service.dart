// lib/services/ia_service.dart

import 'dart:async';
import 'router_service.dart';

typedef VoiceCallback = void Function(String msg);

class IAService {
  final VoiceCallback voiceCallback;
  final RouterService routerService;

  List<DeviceModel> devices = [];
  Map<String, double> trafficData = {};

  IAService({required this.voiceCallback, required this.routerService});

  // Inicializa monitoramento contínuo
  void startMonitoring({Duration interval = const Duration(seconds: 5)}) {
    Timer.periodic(interval, (timer) async {
      await _updateDevices();
      await _analyzeTraffic();
      await _detectSuspiciousDevices();
    });
  }

  // Atualiza a lista de dispositivos com tráfego real
  Future<void> _updateDevices() async {
    devices = await routerService.getDevices();
    trafficData.clear();
    for (var d in devices) {
      double mbps = await routerService.getDeviceTraffic(d.mac);
      trafficData[d.mac] = mbps;
    }
  }

  // Detecta dispositivos suspeitos
  Future<void> _detectSuspiciousDevices() async {
    for (var d in devices) {
      if (d.type.contains('Desconhecido') || d.manufacturer == 'Desconhecido') {
        voiceCallback('Dispositivo suspeito detectado: ${d.name}');
        await routerService.blockDevice(d.mac);
        voiceCallback('${d.name} foi bloqueado automaticamente.');
      }
    }
  }

  // Analisa tráfego e aplica ações automáticas
  Future<void> _analyzeTraffic() async {
    for (var d in devices) {
      double mbps = trafficData[d.mac] ?? 0;

      // Exemplo de regra: TV >20 Mbps e console/PC ativo → prioriza jogo
      if (d.type.contains('TV') && mbps > 20) {
        DeviceModel? gameDevice = devices.firstWhere(
            (dev) => dev.type.contains('Console') || dev.type.contains('PC'),
            orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));

        if (gameDevice.ip != '') {
          voiceCallback(
              'A TV ${d.name} está consumindo $mbps Mbps. Priorizando ${gameDevice.name} automaticamente.');
          await routerService.prioritizeDevice(gameDevice.mac, priority: 200);
        }
      }

      // Limita dispositivos excedendo limite definido
      if (mbps > 50) {
        voiceCallback('${d.name} ultrapassou 50 Mbps. Limitando automaticamente.');
        await routerService.limitDevice(d.mac, 50);
      }
    }
  }

  // Permite ação manual
  Future<void> blockDevice(DeviceModel device) async {
    await routerService.blockDevice(device.mac);
    voiceCallback('${device.name} bloqueado manualmente.');
  }

  Future<void> limitDevice(DeviceModel device, double mbps) async {
    await routerService.limitDevice(device.mac, mbps);
    voiceCallback('${device.name} limitado a $mbps Mbps.');
  }

  Future<void> prioritizeDevice(DeviceModel device, int priority) async {
    await routerService.prioritizeDevice(device.mac, priority: priority);
    voiceCallback('${device.name} priorizado com prioridade $priority.');
  }
}
