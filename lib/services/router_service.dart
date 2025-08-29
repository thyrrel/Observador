import 'dart:convert';
import 'package:http/http.dart' as http;

/// Estrutura base para armazenar credenciais e IP do roteador
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

/// Serviço principal para gerenciar múltiplos roteadores
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

  /// Conecta ao roteador e retorna se a autenticação foi bem-sucedida
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

  /// Bloqueia um dispositivo pelo IP
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

  /// Limita a velocidade de um dispositivo pelo IP
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

  /// Ajusta prioridade de tráfego para um dispositivo
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

  /// Método genérico para executar comandos específicos do roteador
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

  /// Retorna o roteador pelo IP ou marca
  Router? getRouter({String? ip, String? brand}) {
    return routers.firstWhere(
      (r) => (ip != null && r.ip == ip) || (brand != null && r.brand == brand),
      orElse: () => null,
    );
  }

  /// Atualiza credenciais do roteador
  void updateCredentials(Router router, String username, String password) {
    router.username = username;
    router.password = password;
  }
}
