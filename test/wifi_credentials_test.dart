import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/wifi_credentials_service.dart';

void main() {
  test('WifiCredentialsService salva e recupera credenciais', () {
    final wifi = WifiCredentialsService();
    wifi.saveCredentials('SSID1', 'senha123');

    expect(wifi.getPassword('SSID1'), 'senha123');

    wifi.removeCredentials('SSID1');
    expect(wifi.getPassword('SSID1'), null);
  });
}
