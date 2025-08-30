import 'package:flutter_test/flutter_test.dart';
import 'package:observador/providers/device_provider.dart';
import 'package:observador/services/network_service.dart';

class MockNetworkService extends NetworkService {
  @override
  List<NetworkDevice> devices = [
    NetworkDevice(name: 'PC1', ip: '192.168.0.2', mac: 'AA:BB:CC:01', blocked: false),
  ];

  @override
  void toggleBlock(NetworkDevice device) {
    device.blocked = !device.blocked;
  }
}

void main() {
  late MockNetworkService networkService;
  late DeviceProvider deviceProvider;

  setUp(() {
    networkService = MockNetworkService();
    deviceProvider = DeviceProvider(networkService);
  });

  test('Inicializa com dispositivos', () {
    expect(deviceProvider.devices.isNotEmpty, true);
  });

  test('Alterna bloqueio de dispositivo', () {
    final device = deviceProvider.devices[0];
    deviceProvider.toggleBlockDevice(device);
    expect(device.blocked, true);
  });
}
