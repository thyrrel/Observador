// lib/services/cortex_service.dart
import 'dart:async';
import 'device_model.dart';
import 'router_service.dart';
import 'notification_service.dart';

typedef VoiceCallback = void Function(String msg);

class CortexService {
  final RouterService routerService;
  final NotificationService notificationService;
  final VoiceCallback voiceCallback;

  List<DeviceModel> devices = [];
  Map<String, List<double>> trafficHistory = {};
  Map<String, String> deviceUsageType = {};

  Timer? _monitorTimer;

  CortexService({
    required this.routerService,
    required this.notificationService,
    required this.voiceCallback,
  });

  void startMonitoring({int intervalSeconds = 5}) {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      await _updateDevices();
      _analyzeTraffic();
    });
  }

  void stopMonitoring() => _monitorTimer?.cancel();

  Future<void> _updateDevices() async {
    devices = await routerService.getConnectedDevices();
    for (var d in devices) {
      trafficHistory[d.ip] ??= [];
      double mbps = await routerService.getDeviceTraffic(d.mac);
      trafficHistory[d.ip]?.add(mbps);
      if (trafficHistory[d.ip]!.length > 10) trafficHistory[d.ip]!.removeAt(0);
    }
  }

  void _analyzeTraffic() {
    for (var d in devices) {
      double currentMbps = trafficHistory[d.ip]?.last ?? 0;
      String usageType = deviceUsageType[d.ip] ?? d.type;

      if (d.type.contains('Desconhecido')) _notify('Dispositivo suspeito detectado: ${d.name}');

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

  void _prioritizeDevice(DeviceModel device, {int priority = 200}) {
    routerService.prioritizeDevice(device.mac, priority: priority);
    _notify('Dispositivo ${device.name} priorizado com QoS $priority.');
  }

  void _notify(String msg) {
    voiceCallback(msg);
    notificationService.showNotification('C.O.R.T.E.X.', msg);
  }

  void setDeviceUsageType(String ip, String type) => deviceUsageType[ip] = type;

  List<double> getTrafficHistory(String ip) => trafficHistory[ip] ?? [];

  void clearHistory() => trafficHistory.clear();
}
