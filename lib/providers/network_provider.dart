import 'package:flutter/foundation.dart';
import '../services/network_service.dart';

class NetworkProvider extends ChangeNotifier {
  final NetworkService _networkService = NetworkService();
  bool _loading = false;

  List<NetworkDevice> get devices => _networkService.devices;
  bool get loading => _loading;

  NetworkProvider() {
    _networkService.addListener(notifyListeners);
    loadNetworkData();
  }

  Future<void> loadNetworkData() async {
    _loading = true;
    notifyListeners();

    await _networkService.scanNetwork();

    _loading = false;
    notifyListeners();
  }

  void toggleBlock(NetworkDevice device) {
    _networkService.toggleBlock(device);
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }
}
