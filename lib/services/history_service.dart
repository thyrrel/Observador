// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 history_service.dart - Serviço para registro e persistência de eventos ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'storage_service.dart';

class HistoryService {
  final StorageService storageService;
  final String _historyKey = 'network_history';

  HistoryService({required this.storageService});

  Future<List<String>> getHistory() async {
    final String? data = await storageService.read(_historyKey);
    return data?.split(',') ?? <String>[];
  }

  // 💡 CORREÇÃO: Renomeado de addEntry para logEvent para resolver o erro em home_screen.dart
  Future<void> logEvent(String entry) async {
    final List<String> history = await getHistory();
    history.add(entry);
    await storageService.save(_historyKey, history.join(','));
  }

  Future<void> clearHistory() async {
    await storageService.delete(_historyKey);
  }
}

// Sugestões
// - 🛡️ Adicionar limite de tamanho ao histórico (ex: últimos 100 eventos)
// - 🔤 Permitir ordenação ou filtragem por data se os registros incluírem timestamp
// - 📦 Migrar para armazenamento estruturado (ex: JSON ou SQLite) para maior flexibilidade
// - 🧩 Criar método `containsEntry(String entry)` para facilitar verificações
// - 🎨 Expor stream ou callback para refletir atualizações em tempo real na UI

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
