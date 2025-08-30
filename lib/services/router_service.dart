// lib/services/router_service.dart
import '../models/device_model.dart';

class RouterService {
  Future<List<DeviceModel>> getConnectedDevices() async {
    // Aqui normalmente você chamaria a API do roteador
    return [];
  }

  Future<void> blockDevice(String ip, String mac) async {}
  Future<void> limitDevice(String ip, String mac, int limitKbps) async {}
  Future<void> prioritizeDevice(String ip, String mac, {int priority = 200}) async {}
  Future<void> updateDevice(DeviceModel device) async {}
}
