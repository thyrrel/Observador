class NetworkDevice {
  final String id;
  final String name;
  final String ip;

  NetworkDevice({
    required this.id,
    required this.name,
    required this.ip,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ip': ip,
    };
  }
}
