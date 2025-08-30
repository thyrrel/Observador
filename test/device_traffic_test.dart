import 'package:flutter_test/flutter_test.dart';
import 'package:observador/models/device_traffic.dart';

void main() {
  test('DeviceTraffic toMap e fromMap', () {
    final traffic = DeviceTraffic(
      ip: '192.168.0.10',
      mac: 'AA:BB:CC:DD:EE:FF',
      bytesSent: 1024,
      bytesReceived: 2048,
      timestamp: DateTime.now(),
    );

    final map = traffic.toMap();
    final newTraffic = DeviceTraffic.fromMap(map);

    expect(newTraffic.ip, traffic.ip);
    expect(newTraffic.mac, traffic.mac);
    expect(newTraffic.bytesSent, traffic.bytesSent);
    expect(newTraffic.bytesReceived, traffic.bytesReceived);
  });
}
