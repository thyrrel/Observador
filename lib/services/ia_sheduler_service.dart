// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 ia_scheduler_service.dart - Agendador de tarefas periódicas para IA ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:async';

typedef ScheduledTask = void Function();

class IASchedulerService {
  final List<Timer> _timers = [];

  void scheduleTask(Duration interval, ScheduledTask task) {
    final Timer timer = Timer.periodic(interval, (_) => task());
    _timers.add(timer);
  }

  void cancelAll() {
    for (final Timer timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }
}

// Sugestões
// - 🛡️ Adicionar verificação para evitar agendamentos duplicados
// - 🔤 Permitir nomear tarefas para facilitar cancelamento seletivo
// - 📦 Expor stream de eventos para monitoramento externo
// - 🧩 Criar método `cancelTask(int index)` para controle granular
// - 🎨 Integrar com UI para exibir tarefas agendadas em tempo real

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
