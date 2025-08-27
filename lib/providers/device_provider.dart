import 'package:flutter/foundation.dart';
import '../services/network_service.dart';

class DeviceProvider extends ChangeNotifier {
  final NetworkService _networkService;
  List<NetworkDevice> _devices = [];

  DeviceProvider(this._networkService) {
    _devices = _networkService.devices;
    _networkService.addListener(_updateDevices);
  }

  List<NetworkDevice> get devices => _devices;

  void _updateDevices() {
    _devices = _networkService.devices;
    notifyListeners();
  }

  void toggleBlockDevice(NetworkDevice device) {
    _networkService.toggleBlock(device);
  }

  @override
  void dispose() {
    _networkService.removeListener(_updateDevices);
    super.dispose();
  }
}
