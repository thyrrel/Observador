// lib/services/ia_network_manager.dart
import '../models/device_model.dart';
import 'router_service.dart';

typedef VoiceCallback = void Function(String msg);

class IANetworkManager {
  final VoiceCallback voiceCallback;
  final RouterService routerService;
  List<DeviceModel> devices = [];

  IANetworkManager({required this.voiceCallback, required this.routerService});

  /// Inicializa a lista de dispositivos e começa a análise
  void startMonitoring(List<DeviceModel> devs) {
    devices = devs;
    _analyzeDevices();
  }

  /// Atualiza o tráfego dos dispositivos e sugere ações
  void setDeviceUsage(Map<String, double> usage) {
    for (var d in devices) {
      double mbps = usage[d.ip] ?? 0;

      // Exemplo: TV consumindo muita banda enquanto jogador ativo
      if (mbps > 20 && d.type.contains('TV')) {
        voiceCallback(
          'A TV ${d.name} está consumindo $mbps Mbps. Deseja priorizar o jogo?',
        );
        _suggestQoS(d);
      }

      // Exemplo: alerta para dispositivo desconhecido
      if (d.type.contains('Desconhecido')) {
        voiceCallback('Dispositivo suspeito detectado: ${d.name}');
      }
    }
  }

  /// Analisa dispositivos conectados
  void _analyzeDevices() {
    for (var d in devices) {
      if (d.type.contains('Desconhecido')) {
        voiceCallback('Dispositivo suspeito detectado: ${d.name}');
      }
    }
  }

  /// Sugere priorização de QoS para jogos
  void _suggestQoS(DeviceModel highTrafficDevice) {
    DeviceModel? gameDevice = devices.firstWhere(
      (d) => d.type.contains('Console') || d.type.contains('PC'),
      orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''),
    );

    if (gameDevice.ip != '') {
      voiceCallback('Sugerindo priorizar ${gameDevice.name}');
      routerService.prioritizeDevice(gameDevice.mac, priority: 200);
    }
  }

  /// Método para bloquear dispositivo
  void blockDevice(DeviceModel device) {
    routerService.blockDevice(device.mac);
    voiceCallback('Dispositivo ${device.name} bloqueado.');
  }

  /// Método para limitar banda de dispositivo
  void limitDevice(DeviceModel device, double maxMbps) {
    routerService.limitDevice(device.mac, maxMbps);
    voiceCallback('Banda de ${device.name} limitada a $maxMbps Mbps.');
  }
}
