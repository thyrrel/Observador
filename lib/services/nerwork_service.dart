import 'dart:async';
import '../models/device_model.dart';

class NetworkService {
  List<DeviceModel> devices = [];

  Future<List<DeviceModel>> scanDevices() async {
    // Aqui você precisa substituir por chamadas reais de rede
    // Para agora, retornamos lista simulada
    devices = [
      DeviceModel(macAddress: "AA:BB:CC:DD:EE:FF", name: "Smartphone João", type: "Phone"),
      DeviceModel(macAddress: "11:22:33:44:55:66", name: "TV Sala", type: "TV"),
    ];
    return devices;
  }

  Future<void> blockDevice(String mac) async {
    var device = devices.firstWhere((d) => d.macAddress == mac);
    device.isBlocked = true;
  }

  Future<void> unblockDevice(String mac) async {
    var device = devices.firstWhere((d) => d.macAddress == mac);
    device.isBlocked = false;
  }

  Future<void> setPriority(String mac, int value) async {
    var device = devices.firstWhere((d) => d.macAddress == mac);
    device.priority = value;
  }
}
