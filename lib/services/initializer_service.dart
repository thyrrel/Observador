// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 initializer.dart - Inicializador de serviços e dependências do sistema ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../services/storage_service.dart';
import '../services/theme_service.dart';
import '../services/notification_service.dart';
import '../services/device_service.dart';
import '../services/remote_ai_service.dart';
import '../services/history_service.dart';
import '../providers/network_provider.dart';

class Initializer {
  void checkAndCreatePlaceholders({
    required StorageService storageService,
    required ThemeService themeService,
    required NotificationService notificationService,
    required DeviceService deviceService,
    required RemoteAIService remoteAIService,
    required HistoryService historyService,
    required NetworkProvider networkProvider,
  }) {
    // ⚠️ Os parâmetros são `required`, portanto nunca serão `null`.
    // Se o objetivo for inicializar instâncias padrão, isso deve ser feito fora deste método.

    // Este método pode ser usado para validações ou chamadas de setup.
    deviceService.initialize();
    remoteAIService.initialize();
    themeService.loadTheme();
    notificationService.setup();
    historyService.getHistory(); // opcional: pré-carregamento
    networkProvider.refreshStatus();
  }
}

// Sugestões
// - 🛡️ Remover uso de `??=` em parâmetros `required` para evitar confusão
// - 🔤 Criar métodos `initialize()` em cada serviço para padronizar setup
// - 📦 Transformar `Initializer` em singleton se for usado globalmente
// - 🧩 Adicionar verificação de estado antes de inicializar (ex: já carregado)
// - 🎨 Integrar com splash screen ou loading indicator durante inicialização

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
