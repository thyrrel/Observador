class DeviceModel {
  String macAddress;
  String name;
  String type;
  bool isBlocked;
  int priority; // Para QoS

  DeviceModel({
    required this.macAddress,
    required this.name,
    required this.type,
    this.isBlocked = false,
    this.priority = 0,
  });
}
