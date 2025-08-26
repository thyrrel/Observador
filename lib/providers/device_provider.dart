import 'package:flutter/foundation.dart';
import '../models/device_model.dart';
import '../services/device_service.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceService _service = DeviceService();
  List<NetworkDevice> get devices => _service.getAllDevices();

  void addDevice(NetworkDevice device) {
    _service.addDevice(device);
    notifyListeners();
  }

  void removeDevice(NetworkDevice device) {
    _service.removeDevice(device);
    notifyListeners();
  }
}
