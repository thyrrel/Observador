// /lib/providers/network_manager.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 NetworkManager - Orquestra rede e decisões IA ┃
// ┃ 🔐 Usa RouterService para ações e monitoramento ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

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

  void startMonitoring({int intervalSeconds = 5}) {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) async {
        await _updateDevices();
        _analyzeTraffic();
      },
    );
  }

  void stopMonitoring() {
    _monitorTimer?.cancel();
  }

  Future<void> _updateDevices() async {
    _loading = true;
    notifyListeners();

    _devices = await routerService.getConnectedDevices();
    for (var d in _devices) {
      _trafficHistory[d.ip] ??= [];
      final mbps = await routerService.getDeviceTraffic(d.mac);
      _trafficHistory[d.ip]?.add(mbps);
      if (_trafficHistory[d.ip]!.length > 10) {
        _trafficHistory[d.ip]?.removeAt(0);
      }
    }

    _loading = false;
    notifyListeners();
  }

  void _analyzeTraffic() {
    for (var d in _devices) {
      final currentMbps = _trafficHistory[d.ip]?.last ?? 0;
      final usageType = _deviceUsageType[d.ip] ?? d.type;

      if (d.type.contains('Desconhecido')) {
        _notify('⚠️ Dispositivo suspeito detectado: ${d.name}');
      }

      if (usageType.contains('TV') && currentMbps > 20) {
        final gameDevice = _devices.firstWhere(
          (dv) => dv.type.contains('Console') || dv.type.contains('PC'),
          orElse: () => DeviceModel.empty(),
        );

        if (gameDevice.ip.isNotEmpty) {
          voiceCallback('📺 TV ${d.name} usando $currentMbps Mbps. Priorizando ${gameDevice.name}.');
          prioritizeDevice(gameDevice);
        }
      }
    }
  }

  Future<void> prioritizeDevice(DeviceModel device, {int priority = 200}) async {
    await routerService.limitDevice(device.ip, device.mac, priority);
    _notify('🚀 ${device.name} priorizado com QoS $priority.');
  }

  Future<void> toggleBlock(DeviceModel device) async {
    final success = device.blocked
        ? await routerService.unblockDevice(device.ip, device.mac)
        : await routerService.blockDevice(device.ip, device.mac);

    if (success) {
      device.blocked = !device.blocked;
      _notify(device.blocked
          ? '🔒 ${device.name} bloqueado'
          : '🔓 ${device.name} desbloqueado');
      notifyListeners();
    }
  }

  void _notify(String msg) async {
    voiceCallback(msg);
    final androidDetails = AndroidNotificationDetails(
      'network_alerts',
      'Network Alerts',
      channelDescription: 'Alertas da rede e IA',
      importance: Importance.max,
      priority: Priority.high,
    );
    final platformDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, 'C.O.R.T.E.X.', msg, platformDetails);
  }

  void setDeviceUsageType(String ip, String type) {
    _deviceUsageType[ip] = type;
  }

  List<double> getTrafficHistory(String ip) => _trafficHistory[ip] ?? [];

  void clearHistory() {
    _trafficHistory.clear();
  }

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
