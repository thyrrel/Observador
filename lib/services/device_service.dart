import '../models/device_model.dart';

class DeviceService {
  final List<NetworkDevice> _devices = [];

  List<NetworkDevice> getAllDevices() => _devices;

  void addDevice(NetworkDevice device) {
    _devices.add(device);
  }

  void removeDevice(NetworkDevice device) {
    _devices.removeWhere((d) => d.mac == device.mac);
  }
}
