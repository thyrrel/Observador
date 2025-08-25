class DeviceModel {
  String ip;
  String mac;
  String manufacturer;
  String type;
  String name;
  bool isBlocked;

  DeviceModel({
    required this.ip,
    required this.mac,
    required this.manufacturer,
    required this.type,
    required this.name,
    this.isBlocked = false,
  });
}
