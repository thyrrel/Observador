import 'package:flutter/material.dart';
import '../services/network_service.dart';

class NetworkProvider with ChangeNotifier {
  final NetworkService _networkService = NetworkService();

  List<NetworkDevice> get devices => _networkService.devices;

  NetworkProvider() {
    _networkService.addListener(() {
      notifyListeners();
    });
  }

  Future<void> refreshNetwork() async {
    await _networkService.scanNetwork();
  }

  void toggleBlock(NetworkDevice device) {
    _networkService.toggleBlock(device);
  }
}
