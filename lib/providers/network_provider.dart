import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../services/network_service.dart';

class NetworkProvider extends ChangeNotifier {
  final NetworkService _networkService = NetworkService();
  List<DeviceModel> devices = [];

  Future<void> refreshDevices() async {
    devices = await _networkService.getDevices();
    notifyListeners();
  }

  void toggleBlock(DeviceModel device) {
    device.blocked = !device.blocked;
    _networkService.setBlock(device.ip, device.blocked);
    notifyListeners();
  }
}
