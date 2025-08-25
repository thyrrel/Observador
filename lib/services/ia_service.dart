import '../models/device_model.dart';

class IAService {
  final Function(String message) voiceCallback;

  IAService({required this.voiceCallback});

  void analyzeDevices(List<DeviceModel> devices) {
    for (var d in devices) {
      if (d.type == 'Desconhecido') {
        _notifyVoice('Dispositivo suspeito detectado: ${d.mac}');
      }
    }
  }

  void analyzeTraffic(List<DeviceModel> devices, Map<String, double> usageMbps) {
    for (var d in devices) {
      double mbps = usageMbps[d.ip] ?? 0;
      if (mbps > 20 && d.type.contains("TV")) {
        _notifyVoice('A TV ${d.name} está consumindo $mbps Mbps. Deseja priorizar seu jogo?');
      }
    }
  }

  void _notifyVoice(String message) {
    voiceCallback(message);
  }
}
