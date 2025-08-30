import 'package:flutter_test/flutter_test.dart';
import 'package:observador/providers/device_provider.dart';
import 'package:observador/services/network_service.dart';

class MockNetworkService extends NetworkService {
  @override
  List<NetworkDevice> get devices => [
        NetworkDevice(ip: '192.168.0.2', mac: 'AA:BB:CC:DD:EE:01', name: 'PC1', blocked: false),
        NetworkDevice(ip: '192.168.0.3', mac: 'AA:BB:CC:DD:EE:02', name: 'Phone', blocked: true),
      ];
}

void main() {
  test('DeviceProvider lista dispositivos e toggle', () {
    final service = MockNetworkService();
    final provider = DeviceProvider(service);

    expect(provider.devices.length, 2);
    expect(provider.devices[0].name, 'PC1');

    provider.toggleBlockDevice(provider.devices[0]);
    expect(provider.devices[0].blocked, true);
  });
}
