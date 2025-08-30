import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/bluetooth_service.dart';

void main() {
  test('BluetoothService scan e conexão simulada', () async {
    final bt = BluetoothService();

    expect(bt.devices.isEmpty, true);

    await bt.scanDevices();
    expect(bt.devices.isNotEmpty, true);

    bool connected = await bt.connect(bt.devices.first);
    expect(connected, true);
  });
}
