import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/ai_network_service.dart';
import 'package:observador/models/device_model.dart';

class MockRouterService {
  Future<List<DeviceModel>> getConnectedDevices() async {
    return [
      DeviceModel(ip: '192.168.0.2', mac: 'AA:BB:CC:01', manufacturer: 'TP-Link', type: 'PC', name: 'PC1'),
      DeviceModel(ip: '192.168.0.3', mac: 'AA:BB:CC:02', manufacturer: 'Samsung', type: 'TV', name: 'TV1'),
    ];
  }

  Future<double> getDeviceTraffic(String mac) async {
    return 15.0; // Mbps
  }

  void prioritizeDevice(String mac, {int priority = 200}) {}
}

void main() {
  late IANetworkManager manager;
  late MockRouterService routerService;

  setUp(() {
    routerService = MockRouterService();
    manager = IANetworkManager(
      routerService: routerService,
      voiceCallback: (_) {},
      notificationsPlugin: throw UnimplementedError(),
    );
  });

  test('Atualiza dispositivos e histórico', () async {
    await manager._updateDevices();
    expect(manager.devices.length, 2);
    expect(manager.getTrafficHistory('192.168.0.2').isNotEmpty, true);
  });

  test('Define tipo de uso manualmente', () {
    manager.setDeviceUsageType('192.168.0.2', 'Game');
    expect(manager.deviceUsageType['192.168.0.2'], 'Game');
  });

  test('Limpa histórico', () {
    manager.clearHistory();
    expect(manager.trafficHistory.isEmpty, true);
  });
}
