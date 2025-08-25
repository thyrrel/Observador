class DeviceModel {
  String name;
  String ip;
  String mac;
  String manufacturer;
  String type;
  bool isBlocked;

  DeviceModel({
    required this.name,
    required this.ip,
    required this.mac,
    required this.manufacturer,
    this.type = "Desconhecido",
    this.isBlocked = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'ip': ip,
    'mac': mac,
    'manufacturer': manufacturer,
    'type': type,
    'isBlocked': isBlocked,
  };

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
    name: json['name'],
    ip: json['ip'],
    mac: json['mac'],
    manufacturer: json['manufacturer'],
    type: json['type'],
    isBlocked: json['isBlocked'],
  );
}
