// lib/models/device_model.dart
class DeviceModel {
  String name;
  String ip;
  bool isBlocked;

  DeviceModel({
    required this.name,
    required this.ip,
    this.isBlocked = false,
  });
}
