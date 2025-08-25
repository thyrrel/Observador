import '../models/device_model.dart';

class NetworkService {
  final List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  void addDevice(DeviceModel device) {
    _devices.add(device);
  }

  void removeDevice(String mac) {
    _devices.removeWhere((d) => d.mac == mac);
  }

  void blockIP(String ip) {
    // Aqui a lógica real de bloqueio do IP
    print('Bloqueando IP: $ip');
  }

  void limitIP(String ip) {
    // Aqui a lógica real de limitação de banda
    print('Limitando IP: $ip');
  }

  void setHighPriority(String ip) {
    // Aqui a lógica real de prioridade de rede
    print('Prioridade alta para IP: $ip');
  }
}
