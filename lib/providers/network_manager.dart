// lib/providers/network_manager.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/device_model.dart';
import '../services/router_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef VoiceCallback = void Function(String msg);

class NetworkManager extends ChangeNotifier {
  final RouterService routerService;
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final VoiceCallback voiceCallback;

  List<DeviceModel> _devices = [];
  Map<String, List<double>> _trafficHistory = {};
  Map<String, String> _deviceUsageType = {};
  bool _loading = false;
  Timer? _monitorTimer;

  NetworkManager({
    required this.routerService,
    required this.voiceCallback,
    required this.notificationsPlugin,
  });

  List<DeviceModel> get devices => _devices;
  bool get loading => _loading;

  /// Inicializa monitoramento contínuo
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

  /// Atualiza dispositivos e tráfego
  Future<void> _updateDevices() async {
    _loading = true;
    notifyListeners();

    _devices = await routerService.getConnectedDevices();
    for (var d in _devices) {
      _trafficHistory[d.ip] ??= [];
      double mbps = await routerService.getDeviceTraffic(d.mac);
      _trafficHistory[d.ip]?.add(mbps);
      if (_trafficHistory[d.ip]!.length > 10) _trafficHistory[d.ip]?.removeAt(0);
    }

    _loading = false;
    notifyListeners();
  }

  /// Analisa tráfego e toma decisões automáticas
  void _analyzeTraffic() {
    for (var d in _devices) {
      double currentMbps = _trafficHistory[d.ip]?.last ?? 0;
      String usageType = _deviceUsageType[d.ip] ?? d.type;

      // Dispositivo desconhecido
      if (d.type.contains('Desconhecido')) _notify('Dispositivo suspeito detectado: ${d.name}');

      // Exemplo de priorização: TV vs Console/PC
      if (usageType.contains('TV') && currentMbps > 20) {
        var gameDevice = _devices.firstWhere(
          (dv) => dv.type.contains('Console') || dv.type.contains('PC'),
          orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''),
        );
        if (gameDevice.ip != '') {
          voiceCallback('TV ${d.name} usando $currentMbps Mbps. Priorizando ${gameDevice.name}.');
          prioritizeDevice(gameDevice);
        }
      }
    }
  }

  /// Prioriza dispositivo no roteador
  Future<void> prioritizeDevice(DeviceModel device, {int priority = 200}) async {
    await routerService.prioritizeDevice(device.mac, priority: priority);
    _notify('Dispositivo ${device.name} priorizado com QoS $priority.');
  }

  /// Bloqueia/desbloqueia dispositivo
  Future<void> toggleBlock(DeviceModel device) async {
    if (device.blocked) {
      await routerService.limitDevice(device.ip, device.mac, 1024); // exemplo de liberar
      _notify('Desbloqueio aplicado a ${device.name}');
    } else {
      await routerService.blockDevice(device.ip, device.mac);
      _notify('Bloqueio aplicado a ${device.name}');
    }
    device.blocked = !device.blocked;
    notifyListeners();
  }

  /// Notificação local e feedback de voz
  void _notify(String msg) async {
    voiceCallback(msg);
    var androidDetails = AndroidNotificationDetails(
      'network_alerts',
      'Network Alerts',
      channelDescription: 'Alertas da rede e IA',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, 'C.O.R.T.E.X.', msg, platformDetails);
  }

  /// Define tipo de uso do dispositivo
  void setDeviceUsageType(String ip, String type) {
    _deviceUsageType[ip] = type;
  }

  /// Retorna histórico de tráfego
  List<double> getTrafficHistory(String ip) => _trafficHistory[ip] ?? [];

  /// Limpa histórico
  void clearHistory() {
    _trafficHistory.clear();
  }

  /// Atualiza manualmente os dispositivos
  Future<void> refreshDevices() async {
    await _updateDevices();
    _analyzeTraffic();
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    super.dispose();
  }
}
