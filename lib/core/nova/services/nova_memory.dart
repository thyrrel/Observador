// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🗂️ NovaMemoryService - Armazenamento de decisões IA ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/nova_snapshot.dart';

class NovaMemoryService {
  final List<NovaSnapshot> _recentSnapshots = [];
  final Map<String, String> _deviceInsights = {};

  // Armazena snapshot recente
  void storeSnapshot(NovaSnapshot snapshot) {
    _recentSnapshots.add(snapshot);
    if (_recentSnapshots.length > 50) _recentSnapshots.removeAt(0);
  }

  // Associa insight a dispositivo
  void rememberInsight(String deviceIp, String insight) {
    _deviceInsights[deviceIp] = insight;
  }

  // Recupera insight associado
  String? getInsight(String deviceIp) => _deviceInsights[deviceIp];

  // Verifica se já foi observado recentemente
  bool wasRecentlyObserved(String deviceIp) {
    return _recentSnapshots.any((s) => s.device.ip == deviceIp);
  }

  // Limpa memória
  void clearMemory() {
    _recentSnapshots.clear();
    _deviceInsights.clear();
  }
}
