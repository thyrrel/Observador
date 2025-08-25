import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../models/device_model.dart';

class NetworkProvider with ChangeNotifier {
  final NetworkService _networkService = NetworkService();

  List<DeviceModel> get devices => _networkService.getDevices();

  void addDevice(DeviceModel device) {
    _networkService.addDevice(device);
    notifyListeners();
  }

  void blockIP(String ip) {
    _networkService.blockIP(ip);
    notifyListeners();
  }

  void setHighPriority(String ip) {
    _networkService.setHighPriority(ip);
    notifyListeners();
  }

  void limitIP(String ip, int limit) {
    _networkService.limitIP(ip, limit);
    notifyListeners();
  }
}
