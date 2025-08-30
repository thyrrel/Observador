class DeviceModel {
  final String id;
  String name;
  String ip;
  bool blocked;
  String? icon;

  DeviceModel({
    required this.id,
    required this.name,
    required this.ip,
    this.blocked = false,
    this.icon,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      ip: json['ip'],
      blocked: json['blocked'] ?? false,
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ip': ip,
      'blocked': blocked,
      'icon': icon,
    };
  }
}
