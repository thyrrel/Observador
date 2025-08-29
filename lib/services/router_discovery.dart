// lib/services/router_discovery.dart
import 'dart:convert';
import 'dart:io';
import 'router_service.dart';

class RouterDiscovery {
  final String username;
  final String password;

  RouterDiscovery({required this.username, required this.password});

  // Credenciais padrão conhecidas por marca
  final Map<RouterType, Map<String, String>> defaultCredentials = {
    RouterType.huawei: {'username': 'admin', 'password': 'admin'},
    RouterType.xiaomi: {'username': 'admin', 'password': 'admin'},
    RouterType.tplink: {'username': 'admin', 'password': 'admin'},
    RouterType.asus: {'username': 'admin', 'password': 'admin'},
  };

  Future<List<String>> scanLocalNetwork(String subnet) async {
    List<String> activeIPs = [];
    for (int i = 1; i < 255; i++) {
      final ip = '$subnet.$i';
      try {
        final socket = await Socket.connect(ip, 80, timeout: Duration(milliseconds: 200));
        socket.destroy();
        activeIPs.add(ip);
      } catch (_) {}
    }
    return activeIPs;
  }

  Future<RouterType?> detectRouterType(String ip) async {
    try {
      final request = await HttpClient().getUrl(Uri.parse('http://$ip'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (body.contains('Huawei')) return RouterType.huawei;
      if (body.contains('Xiaomi')) return RouterType.xiaomi;
      if (body.contains('TP-Link')) return RouterType.tplink;
      if (body.contains('ASUS')) return RouterType.asus;
    } catch (_) {}
    return null;
  }

  Future<List<RouterService>> discoverAndLogin(String subnet) async {
    final List<RouterService> routers = [];
    final ips = await scanLocalNetwork(subnet);

    for (String ip in ips) {
      final type = await detectRouterType(ip);
      if (type != null) {
        // Tenta login com credenciais do usuário
        var router = RouterService(type: type, ip: ip, username: username, password: password);
        bool success = await router.login();

        // Se falhar, tenta credenciais padrão
        if (!success) {
          final defaults = defaultCredentials[type]!;
          router = RouterService(type: type, ip: ip, username: defaults['username']!, password: defaults['password']!);
          success = await router.login();
        }

        if (success) routers.add(router);
      }
    }

    return routers;
  }
}
