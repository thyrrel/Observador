import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/ai_network_service.dart';
import '../mocks/router_service_mock.dart'; // você pode criar um mock do RouterService

void main() {
  test('Define tipo de uso do dispositivo', () {
    final router = MockRouterService();
    final ia = IANetworkManager(
      routerService: router,
      voiceCallback: (msg) {},
      notificationsPlugin: null as dynamic,
    );

    ia.setDeviceUsageType('192.168.0.2', 'PC');
    expect(ia.deviceUsageType['192.168.0.2'], 'PC');
  });
}
