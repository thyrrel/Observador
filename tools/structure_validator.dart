// /tools/structure_validator.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧩 StructureValidator - Validador de projeto ┃
// ┃ 🔧 Verifica presença de arquivos essenciais ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:io';

void main() async {
  final requiredFiles = [
    'lib/models/device_model.dart',
    'lib/services/storage_service.dart',
    'lib/providers/network_provider.dart',
    'lib/widgets/device_tile.dart',
    'lib/widgets/loading_indicator.dart',
    'lib/pages/device_list_page.dart',
    'lib/pages/device_details_page.dart',
    'lib/core/app_initializer.dart',
  ];

  stdout.writeln('🔍 Verificando estrutura do projeto...\n');

  int missingCount = 0;

  for (final path in requiredFiles) {
    final file = File(path);
    if (await file.exists()) {
      stdout.writeln('✅ Encontrado: $path');
    } else {
      stdout.writeln('❌ Ausente:   $path');
      missingCount++;
    }
  }

  stdout.writeln('\n📦 Resultado:');
  if (missingCount == 0) {
    stdout.writeln('🎉 Tudo certo! Estrutura completa.');
  } else {
    stdout.writeln('⚠️ $missingCount arquivo(s) ausente(s). Verifique antes de prosseguir.');
  }
}
