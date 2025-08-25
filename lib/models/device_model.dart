class DeviceModel {
  String name;
  String ip;
  String mac;
  String manufacturer;
  String type; // Smartphone, PC, IoT, Tablet, etc.
  bool isBlocked;

  DeviceModel({
    required this.name,
    required this.ip,
    required this.mac,
    required this.manufacturer,
    this.type = "Desconhecido",
    this.isBlocked = false,
  });
}
