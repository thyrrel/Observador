import '../models/device_model.dart';

class NetworkService {
  // Exemplo de lista de dispositivos na rede
  List<DeviceModel> devices = [];

  void addDevice(DeviceModel device) {
    devices.add(device);
  }

  List<DeviceModel> getDevices() {
    return devices;
  }

  // Métodos placeholder
  void setHighPriority(String ip) {
    // Lógica para definir prioridade alta
  }

  void blockIP(String ip) {
    // Lógica para bloquear IP
  }

  void limitIP(String ip, int limit) {
    // Lógica para limitar IP
  }
}
