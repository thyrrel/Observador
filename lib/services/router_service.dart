// [Flutter] lib/services/router_service.dart
import 'package:flutter/material.dart';
import '../adapters/router_unified_adapter.dart';
import '../models/device_model.dart';

class RouterService extends ChangeNotifier {
  final Map<String, RouterUnifiedAdapter> _adapters = {};
  final Map<String, String> _tokens = {};

  // Registrar roteador com IP e tipo
  void registerRouter(String ip, RouterType type) {
    _adapters[ip] = RouterUnifiedAdapter(type);
  }

  // Login para um roteador específico
  Future<bool> login(String ip, String username, String password) async {
    final adapter = _adapters[ip];
    if (adapter == null) return false;

    final token = await adapter.login(ip, username, password);
    if (token != null) {
      _tokens[ip] = token;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Obter clientes conectados
  Future<List<RouterDevice>> getClients(String ip) async {
    final adapter = _adapters[ip];
    final token = _tokens[ip];
    if (adapter == null || token == null) return [];
    return adapter.getClients(ip, token);
  }

  // Bloquear dispositivo
  Future<bool> blockDevice(String ip, String mac) async {
    final adapter = _adapters[ip];
    final token = _tokens[ip];
    if (adapter == null || token == null) return false;
    final success = await adapter.blockDevice(ip, token, mac);
    if (success) notifyListeners();
    return success;
  }

  // Limitar dispositivo
  Future<bool> limitDevice(String ip, String mac, int kbps) async {
    final adapter = _adapters[ip];
    final token = _tokens[ip];
    if (adapter == null || token == null) return false;
    final success = await adapter.limitDevice(ip, token, mac, kbps);
    if (success) notifyListeners();
    return success;
  }

  // Função auxiliar: prioridade (pode ser implementada conforme adapter)
  Future<bool> prioritizeDevice(String ip, String mac, {int priority = 100}) async {
    // Muitos routers não possuem endpoint direto, podemos simular via limit
    return limitDevice(ip, mac, priority * 1024); // kbps
  }

  // Verificar se roteador está logado
  bool isLogged(String ip) => _tokens.containsKey(ip);
}
