// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🗂️ NovaInsightHistoryService - Histórico da IA       ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/nova_insight.dart';

class NovaInsightHistoryService {
  final List<NovaInsight> _history = [];

  // Adiciona insight ao histórico
  void add(NovaInsight insight) {
    _history.add(insight);
    if (_history.length > 100) _history.removeAt(0);
  }

  // Retorna histórico completo (imutável)
  List<NovaInsight> getAll() => List.unmodifiable(_history);

  // Filtra por IP do dispositivo
  List<NovaInsight> getByDevice(String ip) =>
      _history.where((i) => i.device.ip == ip).toList();

  // Verifica se insight já existe para o dispositivo
  bool containsInsight(String ip, String tipo) =>
      _history.any((i) => i.device.ip == ip && i.tipo == tipo);

  // Limpa histórico
  void clear() => _history.clear();
}
