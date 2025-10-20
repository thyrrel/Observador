// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 logger_service.dart - Serviço de registro de logs com persistência   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'storage_service.dart';

class LoggerService {
  final StorageService storageService;
  final String _logKey = 'app_logs';

  LoggerService({required this.storageService});

  Future<void> log(String message) async {
    final List<String> logs = await getLogs();
    final String timestamped = '${DateTime.now()}: $message';
    logs.add(timestamped);
    await storageService.save(_logKey, logs.join('\n'));
  }

  Future<List<String>> getLogs() async {
    final String? data = await storageService.read(_logKey);
    return data?.split('\n') ?? <String>[];
  }

  Future<void> clearLogs() async {
    await storageService.delete(_logKey);
  }
}

// Sugestões
// - 🛡️ Adicionar limite de tamanho (ex: manter apenas os últimos 500 logs)
// - 🔤 Criar método `filterLogs(String keyword)` para buscas específicas
// - 📦 Migrar para estrutura JSON com campos `timestamp`, `level`, `message`
// - 🧩 Adicionar suporte a níveis de log (`info`, `warning`, `error`)
// – 🎨 Expor stream para UI reativa ou exportação de logs // 💡 CORREÇÃO

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
