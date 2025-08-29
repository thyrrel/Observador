class DeviceModel {
  final String ip;
  final String mac;
  final String name;
  final String type;
  bool isBlocked;

  DeviceModel({
    required this.ip,
    required this.mac,
    required this.name,
    required this.type,
    this.isBlocked = false,
  });
}
