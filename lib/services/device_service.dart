// lib/services/device_service.dart
import '../models/device_model.dart';

class DeviceService {
  final List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  void addDevice(DeviceModel device) {
    _devices.add(device);
  }

  void removeDevice(String mac) {
    _devices.removeWhere((d) => d.mac == mac);
  }

  void toggleBlock(String mac) {
    final device = _devices.firstWhere((d) => d.mac == mac, orElse: () => DeviceModel.empty());
    if (device.ip != '') device.blocked = !device.blocked;
  }
}
