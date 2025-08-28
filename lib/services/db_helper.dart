import '../models/device_traffic.dart';

class DBHelper {
  DBHelper();

  // Exemplo de dados simulados; futuramente substitua por dados reais
  Future<List<DeviceTraffic>> last7Days() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula delay de DB

    return [
      DeviceTraffic(deviceName: 'Dispositivo 1', rxBytes: 1024, txBytes: 512),
      DeviceTraffic(deviceName: 'Dispositivo 2', rxBytes: 2048, txBytes: 1024),
      DeviceTraffic(deviceName: 'Dispositivo 3', rxBytes: 512, txBytes: 256),
    ];
  }
}
