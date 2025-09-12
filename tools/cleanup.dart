// /tools/cleanup.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧹 Cleanup - Limpeza de arquivos temporários ┃
// ┃ 🔧 Remove mocks, logs e estruturas de teste ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:io';

void main() async {
  final targets = [
    'mock_devices.json',
    'logs/debug.log',
    'temp/',
  ];

  for (final path in targets) {
    final file = File(path);
    final dir = Directory(path);

    if (await file.exists()) {
      await file.delete();
      stdout.writeln('🗑️ Arquivo removido: $path');
    } else if (await dir.exists()) {
      await dir.delete(recursive: true);
      stdout.writeln('🧹 Pasta removida: $path');
    } else {
      stdout.writeln('⚠️ Não encontrado: $path');
    }
  }

  stdout.writeln('\n✅ Limpeza concluída!');
}
