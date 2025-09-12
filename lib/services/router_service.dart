// /lib/services/router_service.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🔧 RouterService - Interface entre app e adaptadores ┃
// ┃ 🧠 Gerencia sessão, delega ações e abstrai complexidade ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/device_model.dart';
import '../adapters/routers/router_unified_adapter.dart';
import '../adapters/routers/router_session.dart';
import '../adapters/routers/router_type.dart';

class RouterService {
  late final RouterUnifiedAdapter _adapter;
  RouterSession? _session;

  void initialize(RouterType type) {
    _adapter = RouterUnifiedAdapter(type, debugMode: true);
  }

  Future<bool> login(String ip, String username, String password) async {
    final session = await _adapter.login(ip, username, password);
    if (session != null) {
      _session = session;
      return true;
    }
    return false;
  }

  Future<List<DeviceModel>> getConnectedDevices() async {
    if (_session == null) return [];
    final raw = await _adapter.getClients(_session!.token, _session!.token);
    return raw.map((r) => DeviceModel.fromRouter(r)).toList();
  }

  Future<bool> blockDevice(String ip, String mac) async {
    if (_session == null) return false;
    return _adapter.blockDevice(ip, _session!.token, mac);
  }

  Future<bool> unblockDevice(String ip, String mac) async {
    if (_session == null) return false;
    return _adapter.unblockDevice(ip, _session!.token, mac);
  }

  Future<bool> limitDevice(String ip, String mac, int kbps) async {
    if (_session == null) return false;
    return _adapter.limitDevice(ip, _session!.token, mac, kbps);
  }

  Future<bool> removeLimit(String ip, String mac) async {
    if (_session == null) return false;
    return _adapter.removeLimit(ip, _session!.token, mac);
  }

  Future<double> getDeviceTraffic(String mac) async {
    // Placeholder: implementar com base em adaptador específico
    return 0.0;
  }

  RouterType? get currentType => _session?.type;
}
