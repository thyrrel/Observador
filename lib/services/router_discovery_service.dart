// lib/services/router_discovery_service.dart
import '../models/device_model.dart';

class RouterDiscoveryService {
  final List<DeviceModel> _routers = [];

  List<DeviceModel> get routers => _routers;

  void addRouter(DeviceModel router) {
    _routers.add(router);
  }

  void removeRouter(String ip) {
    _routers.removeWhere((r) => r.ip == ip);
  }
}
