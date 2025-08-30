// lib/services/network_service.dart
import '../models/device_model.dart';

class NetworkService {
  final List<DeviceModel> _devices = [];
  bool loading = false;

  List<DeviceModel> get devices => _devices;

  Future<void> loadNetworkData() async {
    loading = true;
    await Future.delayed(const Duration(seconds: 1)); // simulação de fetch
    loading = false;
  }

  void addDevice(DeviceModel device) {
    _devices.add(device);
  }

  void removeDevice(String mac) {
    _devices.removeWhere((d) => d.mac == mac);
  }

  void toggleBlock(DeviceModel device) {
    device.blocked = !device.blocked;
  }
}
