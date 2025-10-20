// /lib/adapters/routers/router_unified_adapter.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 RouterUnifiedAdapter - Delegador universal de adaptadores ┃
// ┃ 🔌 Encaminha chamadas para Xiaomi, TP-Link, Huawei etc. ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../../models/device_model.dart';
import '../../models/router_device.dart'; // 💡 CORREÇÃO: Adicionada importação para RouterDevice
import 'router_adapter.dart';
import 'router_session.dart';
import 'router_type.dart';

import 'xiaomi_adapter.dart';
import 'tplink_adapter.dart';
import 'huawei_adapter.dart';
import 'intelbras_adapter.dart';
import 'mikrotik_adapter.dart';
import 'ubiquiti_adapter.dart';

class RouterUnifiedAdapter implements RouterAdapter {
  final RouterAdapter _adapter;

  RouterUnifiedAdapter(RouterType type, {bool debugMode = false})
      : _adapter = switch (type) {
          RouterType.Xiaomi    => XiaomiAdapter(debugMode: debugMode),
          RouterType.TPLink    => TPLinkAdapter(debugMode: debugMode),
          RouterType.Huawei    => HuaweiAdapter(debugMode: debugMode),
          RouterType.Intelbras => IntelbrasAdapter(debugMode: debugMode),
          RouterType.MikroTik  => MikroTikAdapter(debugMode: debugMode),
          RouterType.Ubiquiti  => UbiquitiAdapter(debugMode: debugMode),
        };

  @override
  Future<RouterSession?> login(String ip, String username, String password) =>
      _adapter.login(ip, username, password);

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) =>
      _adapter.getClients(ip, token);

  @override
  Future<bool> blockDevice(String ip, String token, String mac) =>
      _adapter.blockDevice(ip, token, mac);

  @override
  Future<bool> unblockDevice(String ip, String token, String mac) =>
      _adapter.unblockDevice(ip, token, mac);

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) =>
      _adapter.limitDevice(ip, token, mac, limit);

  @override
  Future<bool> removeLimit(String ip, String token, String mac) =>
      _adapter.removeLimit(ip, token, mac);
}
