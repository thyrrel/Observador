import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/router_service.dart';
import 'package:observador/models/device_model.dart';

class MockRouterService extends RouterService {
  List<DeviceModel> devices = [];

  @override
  Future<void> blockDevice(String ip, String mac) async {
    final d = devices.firstWhere((d) => d.ip == ip);
    d.blocked = true;
  }

  @override
  Future<void> limitDevice(String ip, String mac, int limit) async {
    final d = devices.firstWhere((d) => d.ip == ip);
    d.blocked = false;
  }

  @override
  Future<void> prioritizeDevice(String mac, {int priority = 200}) async {}
}

void main() {
  late MockRouterService router;

  setUp(() {
    router = MockRouterService();
    router.devices = [
      DeviceModel(ip: '192.168.0.2', mac: 'AA:BB:CC:01', manufacturer: 'TP-Link', type: 'PC', name: 'PC1'),
    ];
  });

  test('Bloqueio e desbloqueio de dispositivo', () async {
    await router.blockDevice('192.168.0.2', 'AA:BB:CC:01');
    expect(router.devices[0].blocked, true);

    await router.limitDevice('192.168.0.2', 'AA:BB:CC:01', 1024);
    expect(router.devices[0].blocked, false);
  });
}
