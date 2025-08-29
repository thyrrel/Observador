import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_adapter.dart';
import 'huawei_adapter_backup.dart';
import 'mikrotik_adapter_backup.dart';
import 'xiaomi_adapter_backup.dart';

class UnifiedRouterAdapter implements RouterAdapter {
  final HuaweiAdapter _huawei = HuaweiAdapter();
  final MikrotikAdapter _mikrotik = MikrotikAdapter();
  final XiaomiAdapter _xiaomi = XiaomiAdapter();

  @override
  Future<String?> login(String ip, String username, String password) async {
    final huaweiToken = await _huawei.login(ip, username, password);
    if (huaweiToken != null) return 'huawei:$huaweiToken';

    final mikrotikToken = await _mikrotik.login(ip, username, password);
    if (mikrotikToken != null) return 'mikrotik:$mikrotikToken';

    final xiaomiToken = await _xiaomi.login(ip, username, password);
    if (xiaomiToken != null) return 'xiaomi:$xiaomiToken';

    return null;
  }

  @override
  Future<List<RouterDevice>> getClients(String ip, String token) async {
    if (token.startsWith('huawei:')) return _huawei.getClients(ip, token.split(':')[1]);
    if (token.startsWith('mikrotik:')) return _mikrotik.getClients(ip, token.split(':')[1]);
    if (token.startsWith('xiaomi:')) return _xiaomi.getClients(ip, token.split(':')[1]);
    return [];
  }

  @override
  Future<bool> blockDevice(String ip, String token, String mac) async {
    if (token.startsWith('huawei:')) return _huawei.blockDevice(ip, token.split(':')[1], mac);
    if (token.startsWith('mikrotik:')) return _mikrotik.blockDevice(ip, token.split(':')[1], mac);
    if (token.startsWith('xiaomi:')) return _xiaomi.blockDevice(ip, token.split(':')[1], mac);
    return false;
  }

  @override
  Future<bool> limitDevice(String ip, String token, String mac, int limit) async {
    if (token.startsWith('huawei:')) return _huawei.limitDevice(ip, token.split(':')[1], mac, limit);
    if (token.startsWith('mikrotik:')) return _mikrotik.limitDevice(ip, token.split(':')[1], mac, limit);
    if (token.startsWith('xiaomi:')) return _xiaomi.limitDevice(ip, token.split(':')[1], mac, limit);
    return false;
  }
}
