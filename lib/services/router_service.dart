// lib/services/router_service.dart
import 'routers/router_huawei.dart';
import 'routers/router_asus.dart';
import 'routers/router_xiaomi.dart';
import 'routers/router_tplink.dart';

enum RouterType { huawei, asus, xiaomi, tplink }

class RouterService {
  final RouterType type;
  final String ip;
  final String username;
  final String password;

  dynamic _router;

  RouterService({
    required this.type,
    required this.ip,
    required this.username,
    required this.password,
  }) {
    switch (type) {
      case RouterType.huawei:
        _router = RouterHuawei(ip: ip, username: username, password: password);
        break;
      case RouterType.asus:
        _router = RouterAsus(ip: ip, username: username, password: password);
        break;
      case RouterType.xiaomi:
        _router = RouterXiaomi(ip: ip, username: username, password: password);
        break;
      case RouterType.tplink:
        _router = RouterTPLink(ip: ip, username: username, password: password);
        break;
    }
  }

  /// Autentica no roteador
  Future<bool> login() async {
    return await _router.login();
  }

  /// Bloqueia dispositivo pelo MAC
  Future<bool> blockDevice(String mac) async {
    return await _router.blockDevice(mac);
  }

  /// Desbloqueia dispositivo pelo MAC
  Future<bool> unblockDevice(String mac) async {
    return await _router.unblockDevice(mac);
  }

  /// Limita velocidade de dispositivo (Kbps)
  Future<bool> limitDevice(String mac, int speedKbps) async {
    return await _router.limitDevice(mac, speedKbps);
  }
}
