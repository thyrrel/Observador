import 'package:flutter_test/flutter_test.dart';
import 'package:observador/models/device_traffic.dart';

void main() {
  group('DeviceTraffic', () {
    test('toMap/fromMap', () {
      const ip = '192.168.1.10';
      final original = DeviceTraffic(
        ip: ip,
        name: 'TV',
        rxBytes: 1024,
        txBytes: 512,
        timestamp: DateTime(2024, 6, 1),
      );

      final map = original.toMap();
      final restored = DeviceTraffic.fromMap(map);

      expect(restored.ip, ip);
      expect(restored.rxBytes, 1024);
    });
  });
}
