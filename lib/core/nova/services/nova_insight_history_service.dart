// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🗂️ NovaInsightHistoryService - Histórico da IA       ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/nova_insight.dart';

class NovaInsightHistoryService {
  final List<NovaInsight> _history = [];

  void add(NovaInsight insight) {
    _history.add(insight);
    if (_history.length > 100) _history.removeAt(0);
  }

  List<NovaInsight> getAll() => List.unmodifiable(_history);

  List<NovaInsight> getByDevice(String ip) =>
      _history.where((i) => i.device.ip == ip).toList();

  void clear() => _history.clear();
}
