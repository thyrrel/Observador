class DeviceModel {
  final String ip;
  final String mac;
  final String manufacturer;
  bool blocked;

  DeviceModel({
    required this.ip,
    required this.mac,
    required this.manufacturer,
    this.blocked = false,
  });
}
