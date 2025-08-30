// lib/models/device_model.dart
class DeviceModel {
  String ip;
  String mac;
  String manufacturer;
  String type;
  String name;
  bool blocked;

  DeviceModel({
    required this.ip,
    required this.mac,
    required this.manufacturer,
    required this.type,
    required this.name,
    this.blocked = false,
  });

  // Converte JSON em DeviceModel
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      ip: json['ip'] ?? '',
      mac: json['mac'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      blocked: json['blocked'] ?? false,
    );
  }

  // Converte DeviceModel em JSON
  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'mac': mac,
      'manufacturer': manufacturer,
      'type': type,
      'name': name,
      'blocked': blocked,
    };
  }
}
