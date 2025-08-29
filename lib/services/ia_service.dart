import 'package:flutter/material.dart';
import '../models/device_model.dart';
import 'router_service.dart';
import 'ia_network_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef VoiceCallback = void Function(String msg);

class IAService {
  final VoiceCallback voiceCallback;
  final RouterService routerService;
  final IANetworkService networkService;
  final FlutterLocalNotificationsPlugin notifications;
  List<DeviceModel> devices = [];

  IAService({
    required this.voiceCallback,
    required this.routerService,
    required this.networkService,
    required this.notifications,
  });

  // Inicializa monitoramento contínuo
  void startMonitoring() {
    networkService.onTrafficUpdate((Map<String, double> usage) {
      _analyzeTraffic(devices, usage);
    });
  }

  void updateDevices(List<DeviceModel> devs) {
    devices = devs;
  }

  // Analisa dispositivos e identifica desconhecidos
  void analyzeDevices() {
    for (var d in devices) {
      if (d.type.contains('Desconhecido')) {
        voiceCallback('Dispositivo suspeito detectado: ${d.name}');
        _sendNotification('Alerta de segurança', 'Dispositivo suspeito: ${d.name}');
      }
    }
  }

  // Analisa tráfego e aplica QoS conforme hábitos
  void _analyzeTraffic(List<DeviceModel> devs, Map<String, double> usage) {
    for (var d in devs) {
      double mbps = usage[d.ip] ?? 0;
      if (mbps > 20 && d.type.contains('TV')) {
        voiceCallback('A TV ${d.name} está consumindo $mbps Mbps. Priorizando jogo.');
        _suggestQoS(d);
      }
      // Antecipação de hábitos: streaming / jogos
      if (d.name.toLowerCase().contains('console') && mbps < 10) {
        voiceCallback('Console ${d.name} detectado. Garantindo banda.');
        _suggestQoS(d);
      }
    }
  }

  // Prioriza dispositivo na rede
  void _suggestQoS(DeviceModel targetDevice) {
    DeviceModel? mainDevice = devices.firstWhere(
      (d) => d.type.contains('Console') || d.type.contains('PC'),
      orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''),
    );

    if (mainDevice.ip != '') {
      voiceCallback('Priorizando ${mainDevice.name}');
      routerService.prioritizeDevice(mainDevice.mac, priority: 200);
      _sendNotification('QoS aplicada', 'Banda direcionada para ${mainDevice.name}');
    }
  }

  // Envia notificação local
  Future<void> _sendNotification(String title, String body) async {
    await notifications.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ia_channel',
          'IA Alerts',
          channelDescription: 'Notificações de IA',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
