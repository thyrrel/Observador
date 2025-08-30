// lib/providers/dns_manager.dart
import 'package:flutter/foundation.dart';

typedef DNSNotification = void Function(String msg);

class DNSManager extends ChangeNotifier {
  final DNSNotification? notifyCallback;

  Map<String, dynamic> _dnsRecords = {}; // domínio -> IP ou info
  Map<String, dynamic> get dnsRecords => _dnsRecords;

  bool _loading = false;
  bool get loading => _loading;

  DNSManager({this.notifyCallback});

  /// Carrega registros DNS iniciais
  void loadRecords(Map<String, dynamic> records) {
    _dnsRecords = records;
    notifyListeners();
  }

  /// Atualiza ou adiciona um registro DNS
  void setRecord(String domain, dynamic value) {
    _dnsRecords[domain] = value;
    notifyCallback?.call('Registro DNS atualizado: $domain -> $value');
    notifyListeners();
  }

  /// Remove um registro DNS
  void removeRecord(String domain) {
    if (_dnsRecords.containsKey(domain)) {
      _dnsRecords.remove(domain);
      notifyCallback?.call('Registro DNS removido: $domain');
      notifyListeners();
    }
  }

  /// Simula recarga de dados (ex: do roteador ou servidor)
  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _loading = false;
    notifyListeners();
    notifyCallback?.call('Registros DNS atualizados');
  }

  /// Limpa todos os registros
  void clearAll() {
    _dnsRecords.clear();
    notifyCallback?.call('Todos os registros DNS foram removidos');
    notifyListeners();
  }
}
