// /tools/tools_launcher.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🚀 ToolsLauncher - Menu de utilitários       ┃
// ┃ 🔧 Exibe opções e orienta uso manual         ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

void main() {
  final tools = {
    1: '🛠️ InitProject         → Cria arquivos base',
    2: '🧪 MockDataGenerator   → Gera dispositivos falsos',
    3: '🧹 Cleanup             → Remove arquivos temporários',
    4: '📘 LogFormatter        → Estiliza mensagens de log',
    5: '🧩 StructureValidator  → Verifica estrutura do projeto',
  };

  print('\n📦 Menu de Utilitários do Observador\n');
  tools.forEach((key, value) => print(' $key. $value'));

  print('\n🔍 Como usar:');
  print(' → Abra o script desejado na pasta /tools');
  print(' → Copie o conteúdo e cole no local apropriado');
  print(' → Use como referência para testes ou estruturação\n');

  print('🎯 Estilo: byThyrrel — visual claro, propósito direto, código afiado\n');
}
