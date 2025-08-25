import '../models/device_model.dart';

class IAService {
  // Exemplo simplificado: detectar dispositivos desconhecidos
  List<DeviceModel> analyzeDevices(List<DeviceModel> devices, List<String> allowedMacs) {
    List<DeviceModel> alerts = [];
    for (var device in devices) {
      if (!allowedMacs.contains(device.mac)) {
        alerts.add(device);
      }
    }
    return alerts; // retornar lista de suspeitos
  }
}
