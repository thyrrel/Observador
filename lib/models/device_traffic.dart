class DeviceTraffic {
  final String ip;
  final String mac;
  final int bytesSent;
  final int bytesReceived;
  final DateTime timestamp;

  DeviceTraffic({
    required this.ip,
    required this.mac,
    required this.bytesSent,
    required this.bytesReceived,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'mac': mac,
      'bytesSent': bytesSent,
      'bytesReceived': bytesReceived,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DeviceTraffic.fromMap(Map<String, dynamic> map) {
    return DeviceTraffic(
      ip: map['ip'],
      mac: map['mac'],
      bytesSent: map['bytesSent'],
      bytesReceived: map['bytesReceived'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
