// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 👁️ NovaObserver - Monitoramento da rede para IA      ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:async';
import '../models/device_model.dart';
import '../services/router_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../nova/nova_core.dart';
import '../models/nova_snapshot.dart';

typedef VoiceCallback = void Function(String msg);

class NovaObserver {
  final RouterService routerService;
  final VoiceCallback voiceCallback;
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final NovaCore novaCore = NovaCore();

  List<DeviceModel> devices = [];
  Map<String, List<double>> trafficHistory = {};
  Map<String, String> deviceUsageType = {};
  Timer? _monitorTimer;

  NovaObserver({
    required this.routerService,
    required this.voiceCallback,
    required this.notificationsPlugin,
  });

  // Inicia monitoramento periódico
  void startMonitoring({int intervalSeconds = 5}) {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      await _updateDevices();
      _analyzeTraffic();
    });
  }

  void stopMonitoring() => _monitorTimer?.cancel();

  // Atualiza lista de dispositivos e tráfego
  Future<void> _updateDevices() async {
    devices = await routerService.getConnectedDevices();
    for (var d in devices) {
      trafficHistory[d.ip] ??= [];
      double mbps = await routerService.getDeviceTraffic(d.mac);
      trafficHistory[d.ip]?.add(mbps);
      if (trafficHistory[d.ip]!.length > 10) trafficHistory[d.ip]?.removeAt(0);
    }
  }

  // Analisa tráfego e envia snapshot para IA
  void _analyzeTraffic() {
    for (var d in devices) {
      double currentMbps = trafficHistory[d.ip]?.last ?? 0;
      String usageType = deviceUsageType[d.ip] ?? d.type;

      final snapshot = NovaSnapshot(
        device: d,
        mbps: currentMbps,
        usageType: usageType,
        history: trafficHistory[d.ip] ?? [],
      );

      novaCore.observe(snapshot);

      // Regras locais (temporárias)
      if (d.type.contains('Desconhecido')) _notify('Dispositivo suspeito detectado: ${d.name}');

      if (usageType.contains('TV') && currentMbps > 20) {
        DeviceModel? gameDevice = devices.firstWhere(
          (d) => d.type.contains('Console') || d.type.contains('PC'),
          orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''),
        );
        if (gameDevice.ip.isNotEmpty) {
          voiceCallback('TV ${d.name} está usando ${currentMbps.toStringAsFixed(2)} Mbps. Priorizando ${gameDevice.name}.');
          _prioritizeDevice(gameDevice);
        }
      }
    }
  }

  // Prioriza dispositivo via QoS
  void _prioritizeDevice(DeviceModel device, {int priority = 200}) {
    routerService.prioritizeDevice(device.mac, priority: priority);
    _notify('Dispositivo ${device.name} priorizado com QoS $priority.');
  }

  // Envia notificação + voz
  void _notify(String msg) async {
    voiceCallback(msg);
    var androidDetails = AndroidNotificationDetails(
      'ia_alerts',
      'IA Alerts',
      channelDescription: 'Alertas da IA',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, 'NOVA', msg, platformDetails);
  }

  // Define tipo de uso manual
  void setDeviceUsageType(String ip, String type) => deviceUsageType[ip] = type;

  // Histórico de tráfego por IP
  List<double> getTrafficHistory(String ip) => trafficHistory[ip] ?? [];

  // Limpa histórico completo
  void clearHistory() => trafficHistory.clear();
}
