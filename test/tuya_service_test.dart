import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/tuya_service.dart';

void main() {
  test('TuyaService envia comandos simulados', () async {
    final tuya = TuyaService();
    bool success = await tuya.sendCommand('device1', 'on');
    expect(success, true);

    final status = await tuya.getStatus('device1');
    expect(status, 'on');
  });
}
