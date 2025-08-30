import 'dart:async';
import '../models/device_model.dart';
import '../services/router_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef VoiceCallback = void Function(String msg);

class IANetworkManager {
  final RouterService routerService;
  final VoiceCallback voiceCallback;
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  List<DeviceModel> devices = [];
  Map<String, List<double>> trafficHistory = {}; // IP -> lista de Mbps
  Map<String, String> deviceUsageType = {}; // IP -> tipo de uso
  Timer? _monitorTimer;

  IANetworkManager({
    required this.routerService,
    required this.voiceCallback,
    required this.notificationsPlugin,
  });

  /// Inicializa o monitoramento contínuo
  void startMonitoring({int intervalSeconds = 5}) {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      await _updateDevices();
      _analyzeTraffic();
    });
  }

  void stopMonitoring() {
    _monitorTimer?.cancel();
  }

  /// Atualiza a lista de dispositivos e tráfego
  Future<void> _updateDevices() async {
    devices = await routerService.getConnectedDevices();
    for (var d in devices) {
      trafficHistory[d.ip] ??= [];
      double mbps = await routerService.getDeviceTraffic(d.mac);
      trafficHistory[d.ip]?.add(mbps);

      // Mantém histórico de últimas 10 leituras
      if (trafficHistory[d.ip]!.length > 10) {
        trafficHistory[d.ip]!.removeAt(0);
      }
    }
  }

  /// Analisa tráfego e hábitos para tomar decisões
  void _analyzeTraffic() {
    for (var d in devices) {
      double currentMbps = trafficHistory[d.ip]?.last ?? 0;
      String usageType = deviceUsageType[d.ip] ?? d.type;

      // Dispositivo desconhecido
      if (d.type.contains('Desconhecido')) {
        _notify('Dispositivo suspeito detectado: ${d.name}');
      }

      // Streaming vs Jogo
      if (usageType.contains('TV') && currentMbps > 20) {
        DeviceModel? gameDevice = devices.firstWhere(
            (d) => d.type.contains('Console') || d.type.contains('PC'),
            orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));

        if (gameDevice.ip != '') {
          voiceCallback('TV ${d.name} está usando $currentMbps Mbps. Priorizando ${gameDevice.name}.');
          _prioritizeDevice(gameDevice);
        }
      }
    }
  }

  /// Prioriza dispositivo no roteador
  void _prioritizeDevice(DeviceModel device, {int priority = 200}) {
    routerService.prioritizeDevice(device.mac, priority: priority);
    _notify('Dispositivo ${device.name} priorizado com QoS $priority.');
  }

  /// Notificação local
  void _notify(String msg) async {
    voiceCallback(msg);
    var androidDetails = AndroidNotificationDetails(
      'ia_alerts',
      'IA Alerts',
      channelDescription: 'Alertas e notificações da IA',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, 'C.O.R.T.E.X.', msg, platformDetails);
  }

  /// Define tipo de uso manualmente ou via aprendizado
  void setDeviceUsageType(String ip, String type) {
    deviceUsageType[ip] = type;
  }

  /// Retorna histórico de tráfego para dashboard
  List<double> getTrafficHistory(String ip) => trafficHistory[ip] ?? [];

  /// Limpa histórico
  void clearHistory() {
    trafficHistory.clear();
  }
}
