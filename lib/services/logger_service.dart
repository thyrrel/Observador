
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📋 LoggerService - Registro interno da IA            ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class LoggerService {
  final List<String> _logs = [];

  // Adiciona log com timestamp ISO
  void log(String msg) {
    final timestamp = DateTime.now().toIso8601String();
    _logs.add('[$timestamp] $msg');
  }

  // Retorna lista imutável de logs
  List<String> getLogs() => List.unmodifiable(_logs);

  // Limpa histórico
  void clear() => _logs.clear();
}
