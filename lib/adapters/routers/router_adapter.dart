// /lib/adapters/routers/router_adapter.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🔌 RouterAdapter - Interface base para adaptadores ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../../models/device_model.dart';
import '../../models/router_device.dart'; // 💡 CORREÇÃO: Adicionada importação para RouterDevice
import 'router_session.dart';

abstract class RouterAdapter {
  Future<RouterSession?> login(String ip, String username, String password);
  Future<List<RouterDevice>> getClients(String ip, String token);
  Future<bool> blockDevice(String ip, String token, String mac);
  Future<bool> unblockDevice(String ip, String token, String mac);
  Future<bool> limitDevice(String ip, String token, String mac, int limit);
  Future<bool> removeLimit(String ip, String token, String mac);
}
