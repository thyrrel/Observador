// lib/services/tuya_service.dart
class TuyaService {
  final Map<String, String> _devices = {}; // deviceId -> token

  void addDevice(String deviceId, String token) {
    _devices[deviceId] = token;
  }

  void removeDevice(String deviceId) {
    _devices.remove(deviceId);
  }

  String? getToken(String deviceId) => _devices[deviceId];

  List<String> get allDevices => _devices.keys.toList();
}
