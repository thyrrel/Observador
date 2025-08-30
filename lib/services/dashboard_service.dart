// lib/services/dashboard_service.dart
import '../models/device_model.dart';

class DashboardService {
  final List<DeviceModel> _devices = [];

  void updateDevices(List<DeviceModel> devices) {
    _devices.clear();
    _devices.addAll(devices);
  }

  List<DeviceModel> get devices => _devices;

  int get totalDevices => _devices.length;

  double get totalTrafficMbps {
    double total = 0;
    for (var d in _devices) {
      total += d.trafficMbps;
    }
    return total;
  }
}
