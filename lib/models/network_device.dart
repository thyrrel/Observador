class NetworkDevice {
  final int? id;
  final String name;
  final String ip;
  final String mac;
  final bool blocked;

  NetworkDevice({
    this.id,
    required this.name,
    required this.ip,
    required this.mac,
    this.blocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ip': ip,
      'mac': mac,
      'blocked': blocked ? 1 : 0,
    };
  }

  factory NetworkDevice.fromMap(Map<String, dynamic> map) {
    return NetworkDevice(
      id: map['id'],
      name: map['name'],
      ip: map['ip'],
      mac: map['mac'],
      blocked: map['blocked'] == 1,
    );
  }
}
