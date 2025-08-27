import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];
  String status = 'Inicializando...';

  Future<void> initBluetooth() async {
    bool isAvailable = await flutterBlue.isAvailable;
    bool isOn = await flutterBlue.isOn;
    if (!isAvailable) {
      status = 'Bluetooth não disponível';
    } else if (!isOn) {
      status = 'Bluetooth desligado';
    } else {
      status = 'Pronto para escanear';
      await scanDevices();
    }
  }

  Future<void> scanDevices() async {
    devices.clear();
    flutterBlue.startScan(timeout: Duration(seconds: 10));
    flutterBlue.scanResults.listen((results) {
      devices = results.map((r) => r.device).toList();
    });
    flutterBlue.stopScan();
    status = 'Escaneamento completo';
  }

  Widget buildBluetoothPanel() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bluetooth: $status'),
            ...devices.map((d) => ListTile(
                  title: Text(d.name.isNotEmpty ? d.name : 'Desconhecido'),
                  subtitle: Text(d.id.toString()),
                )),
          ],
        ),
      ),
    );
  }
}
