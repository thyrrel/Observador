// /tools/log_formatter.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📘 LogFormatter - Estilizador de logs        ┃
// ┃ 🔧 Formata mensagens com timestamp e nível   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:io';

enum LogLevel { info, warning, error }

class LogFormatter {
  static void log(String message, {LogLevel level = LogLevel.info}) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = _levelPrefix(level);
    final formatted = '[$timestamp] $prefix $message';

    stdout.writeln(formatted);
  }

  static String _levelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 'ℹ️ INFO';
      case LogLevel.warning:
        return '⚠️ WARN';
      case LogLevel.error:
        return '❌ ERROR';
    }
  }
}

void main() {
  LogFormatter.log('Sistema iniciado');
  LogFormatter.log('Arquivo não encontrado', level: LogLevel.warning);
  LogFormatter.log('Falha crítica de autenticação', level: LogLevel.error);
}
