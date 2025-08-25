import '../models/device_model.dart';

class NetworkService {
  // Simula dispositivos conectados
  Future<List<DeviceModel>> getDevices() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      DeviceModel(ip: '192.168.0.2', mac: 'AA:BB:CC:DD:EE:01', manufacturer: 'Samsung'),
      DeviceModel(ip: '192.168.0.3', mac: 'AA:BB:CC:DD:EE:02', manufacturer: 'Apple'),
    ];
  }

  void setBlock(String ip, bool block) {
    // Aqui será a lógica real para bloquear dispositivo
    // Futuramente IA pode decidir bloquear automaticamente
  }
}
