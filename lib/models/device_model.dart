// device_model.dart
class DeviceModel {
  String ip;
  String mac;
  String manufacturer;
  String type;
  String name;

  DeviceModel({
    required this.ip,
    required this.mac,
    required this.manufacturer,
    required this.type,
    required this.name,
  });

  // Converte para Map, útil para integração com RouterService
  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'mac': mac,
      'manufacturer': manufacturer,
      'type': type,
      'name': name,
    };
  }

  // Cria DeviceModel a partir de Map
  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      ip: map['ip'] ?? '',
      mac: map['mac'] ?? '',
      manufacturer: map['manufacturer'] ?? 'Desconhecido',
      type: map['type'] ?? '',
      name: map['name'] ?? '',
    );
  }

  // Atualiza dados de dispositivo
  void updateFrom(DeviceModel other) {
    ip = other.ip;
    mac = other.mac;
    manufacturer = other.manufacturer;
    type = other.type;
    name = other.name;
  }
}
