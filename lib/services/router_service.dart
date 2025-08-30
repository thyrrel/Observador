// lib/services/router_service.dart
import 'device_model.dart';

class RouterService {
  Future<List<DeviceModel>> getConnectedDevices() async {
    // Simulação: buscar dispositivos reais de roteador
    return [];
  }

  Future<double> getDeviceTraffic(String mac) async {
    // Simulação: obter tráfego real
    return 0.0;
  }

  Future<void> prioritizeDevice(String mac, {int priority = 200}) async {
    // Configura QoS
  }

  Future<void> blockDevice(String ip, String mac) async {
    // Bloqueia dispositivo
  }

  Future<void> limitDevice(String ip, String mac, int limitKbps) async {
    // Limita banda
  }
}
