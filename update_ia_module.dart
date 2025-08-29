import 'dart:io';

void main() {
  final projectDir = Directory.current.path; // Diretório raiz do seu projeto
  final oldClass = 'IAService';
  final newClass = 'IANetworkManager';
  final oldImport = "import 'services/ia_service.dart';";
  final newImport = "import 'services/ia_network_manager.dart';";

  final files = Directory(projectDir)
      .listSync(recursive: true)
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  for (var file in files) {
    final f = File(file.path);
    String content = f.readAsStringSync();

    // Atualiza imports
    content = content.replaceAll(oldImport, newImport);

    // Substitui instâncias
    content = content.replaceAllMapped(
        RegExp(r'final\s+(\w+)\s*=\s*IAService\(([^)]*)\);'), (match) {
      final varName = match.group(1);
      final args = match.group(2);
      return 'final $varName = IANetworkManager($args);';
    });

    // Substitui chamadas de métodos
    content = content.replaceAll('analyzeDevices', 'startMonitoring');
    content = content.replaceAll('analyzeTraffic', 'setDeviceUsageType');

    f.writeAsStringSync(content);
    print('Arquivo atualizado: ${f.path}');
  }

  print('\n✅ Todas as referências de IAService foram substituídas por IANetworkManager.');
}
