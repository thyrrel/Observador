import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Estrutura base do roteador
class Router {
  final String brand;
  final String ip;
  String username;
  String password;

  Router({
    required this.brand,
    required this.ip,
    required this.username,
    required this.password,
  });
}

/// Serviço para gerenciar múltiplos roteadores e automação
class RouterService {
  final List<Router> routers = [];

  RouterService() {
    _loadDefaultRouters();
  }

  void _loadDefaultRouters() {
    routers.addAll([
      Router(brand: 'Huawei', ip: '192.168.3.1', username: 'admin', password: 'admin'),
      Router(brand: 'TP-Link', ip: '192.168.0.1', username: 'admin', password: 'admin'),
      Router(brand: 'Xiaomi', ip: '192.168.31.1', username: 'admin', password: 'admin'),
      Router(brand: 'Asus', ip: '192.168.1.1', username: 'admin', password: 'admin'),
      Router(brand: 'D-Link', ip: '192.168.0.1', username: 'admin', password: 'admin'),
      Router(brand: 'Netgear', ip: '192.168.1.1', username: 'admin', password: 'password'),
      Router(brand: 'Mercusys', ip: '192.168.1.1', username: 'admin', password: 'admin'),
      Router(brand: 'Tenda', ip: '192.168.0.1', username: 'admin', password: 'admin'),
    ]);
  }

  /// Detecta dispositivos conectados na rede local
  Future<List<String>> scanNetwork(String subnet) async {
    List<String> activeIPs = [];
    for (int i = 1; i < 255; i++) {
      final ip = '$subnet.$i';
      try {
        final result = await Process.run('ping', ['-c', '1', '-W', '1', ip]);
        if (result.exitCode == 0) {
          activeIPs.add(ip);
        }
      } catch (_) {}
    }
    return activeIPs;
  }

  /// Conecta a todos os roteadores automaticamente usando credenciais padrão
  Future<void> connectAll() async {
    for (var router in routers) {
      bool success = await connect(router);
      print('${router.brand} (${router.ip}) conectado: $success');
    }
  }

  /// Conexão individual
  Future<bool> connect(Router router) async {
    try {
      final response = await http.post(
        Uri.parse('http://${router.ip}/login'),
        body: {'username': router.username, 'password': router.password},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao conectar no ${router.brand}: $e');
      return false;
    }
  }

  /// Bloqueio de dispositivo pelo IP
  Future<bool> blockIP(Router router, String ipToBlock) async {
    try {
      final response = await http.post(
        Uri.parse('http://${router.ip}/block_ip'),
        body: {'ip': ipToBlock},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao bloquear IP no ${router.brand}: $e');
      return false;
    }
  }

  /// Limita a velocidade de um dispositivo
  Future<bool> limitIP(Router router, String ipToLimit, int maxMbps) async {
    try {
      final response = await http.post(
        Uri.parse('http://${router.ip}/limit_ip'),
        body: {'ip': ipToLimit, 'speed': maxMbps.toString()},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao limitar IP no ${router.brand}: $e');
      return false;
    }
  }

  /// Prioridade de tráfego
  Future<bool> setHighPriority(Router router, String ip) async {
    try {
      final response = await http.post(
        Uri.parse('http://${router.ip}/priority'),
        body: {'ip': ip, 'priority': 'high'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao definir prioridade no ${router.brand}: $e');
      return false;
    }
  }

  /// Envio de comando genérico
  Future<bool> sendCommand(Router router, String endpoint, Map<String, String> params) async {
    try {
      final response = await http.post(
        Uri.parse('http://${router.ip}/$endpoint'),
        body: params,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao enviar comando no ${router.brand}: $e');
      return false;
    }
  }

  /// Atualiza credenciais
  void updateCredentials(Router router, String username, String password) {
    router.username = username;
    router.password = password;
  }

  /// Retorna roteador por IP ou marca
  Router? getRouter({String? ip, String? brand}) {
    return routers.firstWhere(
      (r) => (ip != null && r.ip == ip) || (brand != null && r.brand == brand),
      orElse: () => null,
    );
  }
}
