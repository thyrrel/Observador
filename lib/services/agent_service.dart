// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 agent_service.dart - Serviço de execução cíclica com controle de log ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:async';

typedef AgentLog = void Function(String msg);

class AgentService {
  AgentService._private();

  static final AgentService instance = AgentService._private();

  AgentLog? _logger;
  bool _running = false;
  Completer<void>? _stopCompleter;

  bool get isRunning => _running;

  void setLogger(AgentLog logger) {
    _logger = logger;
  }

  Future<void> start({Duration interval = const Duration(seconds: 5)}) async {
    if (_running) {
      _logger?.call('AgentService: já em execução.');
      return;
    }

    _running = true;
    _stopCompleter = Completer<void>();

    _logger?.call('AgentService: iniciado em ${DateTime.now()}.');

    await _runLoop(interval);
  }

  Future<void> _runLoop(Duration interval) async {
    while (_running) {
      try {
        // ⚙️ Aqui podem ser chamadas rotinas reais: tráfego, IA, QoS
        _logger?.call('AgentService: ciclo executado em ${DateTime.now()}.');
      } catch (Object error, StackTrace stack) {
        _logger?.call('AgentService: erro no ciclo: $error\n$stack');
      }

      await Future.any([
        Future.delayed(interval),
        _stopCompleter!.future,
      ]);
    }

    _logger?.call('AgentService: loop finalizado.');
  }

  Future<void> stop() async {
    if (!_running) {
      _logger?.call('AgentService: já parado.');
      return;
    }

    _running = false;
    _stopCompleter?.complete();

    await Future.delayed(const Duration(milliseconds: 150));

    _logger?.call('AgentService: parado em ${DateTime.now()}.');
  }

  Future<void> dispose() async {
    await stop();
    _logger = null;
  }
}

// Sugestões
// - 🧩 Extrair `_runLoop` para uma classe separada se for reutilizável
// - 🛡️ Adicionar timeout ou cancelamento externo para ciclos longos
// - 🔤 Tipar `Completer<void>` como `Completer<void>?` com fallback defensivo
// - 📦 Adicionar enum para estados do serviço (`idle`, `running`, `stopped`)
// - 🧼 Usar `Logger` estruturado ao invés de `Function(String)` para logs complexos

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
