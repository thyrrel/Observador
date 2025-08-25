import 'dart:async';
import '../models/device_model.dart';

typedef VoiceCallback = void Function(String message);

class IAService {
  final VoiceCallback? voiceCallback;

  IAService({this.voiceCallback});

  /// Lista de MACs permitidos (pode vir do armazenamento seguro)
  List<String> allowedMacs = [];

  /// Analisar dispositivos e retornar lista de suspeitos
  List<DeviceModel> analyzeDevices(List<DeviceModel> devices) {
    List<DeviceModel> alerts = [];
    for (var device in devices) {
      if (!allowedMacs.contains(device.mac)) {
        alerts.add(device);
        _notifyVoice(
            "Dispositivo suspeito detectado: ${device.name}, fabricante: ${device.manufacturer}");
      }
    }
    return alerts;
  }

  /// Sugere priorização de banda com base no uso
  void analyzeTraffic(List<DeviceModel> devices, Map<String, double> usageMbps) {
    // Exemplo simples: detectar se TV está consumindo > 20 Mbps
    devices.forEach((device) {
      if (device.type.contains("TV") && usageMbps[device.ip] != null) {
        double bandwidth = usageMbps[device.ip]!;
        if (bandwidth > 20) {
          _notifyVoice(
              "A TV está consumindo $bandwidth Mbps. Quer priorizar a rede para seu jogo?");
        }
      }
    });
  }

  /// Previsão de comportamento simples baseado em horários ou padrões
  void predictBehavior(List<DeviceModel> devices, Map<String, DateTime> lastActive) {
    final now = DateTime.now();
    devices.forEach((device) {
      if (lastActive.containsKey(device.mac)) {
        final diff = now.difference(lastActive[device.mac]!);
        if (diff.inMinutes > 120) {
          _notifyVoice(
              "O dispositivo ${device.name} não esteve ativo nas últimas 2 horas. Sem mudanças previstas.");
        }
      }
    });
  }

  /// Função interna para avisos via assistente de voz
  void _notifyVoice(String message) {
    if (voiceCallback != null) voiceCallback!(message);
  }
}
