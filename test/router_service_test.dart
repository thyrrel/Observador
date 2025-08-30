import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/router_service.dart';

void main() {
  test('RouterService bloqueio e prioridade', () async {
    final router = RouterService();

    await router.blockDevice('192.168.0.2', 'AA:BB:CC:DD:EE:01');
    expect(router.blockedDevices.contains('192.168.0.2'), true);

    await router.limitDevice('192.168.0.2', 'AA:BB:CC:DD:EE:01', 1024);
    expect(router.limitedDevices['192.168.0.2'], 1024);

    await router.prioritizeDevice('192.168.0.2', priority: 200);
    expect(router.priorities['192.168.0.2'], 200);
  });
}
