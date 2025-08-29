// lib/models/network_device.dart
import 'device_model.dart';
import 'device_traffic.dart';

class NetworkDevice {
  final RouterDevice device;
  final List<DeviceTraffic> trafficHistory;

  NetworkDevice({
    required this.device,
    List<DeviceTraffic>? trafficHistory,
  }) : trafficHistory = trafficHistory ?? [];

  /// Bytes totais transferidos
  int get totalRx => trafficHistory.fold(0, (sum, t) => sum + t.rxBytes);
  int get totalTx => trafficHistory.fold(0, (sum, t) => sum + t.txBytes);

  /// Adiciona registro diário de tráfego
  void addTraffic(DeviceTraffic t) {
    trafficHistory.add(t);
  }

  /// Retorna se o dispositivo está bloqueado
  bool get isBlocked => device.blocked;
}
