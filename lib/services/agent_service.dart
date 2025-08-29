// lib/services/agent_service.dart
import 'dart:async';

typedef AgentLog = void Function(String msg);

class AgentService {
  AgentService._private();
  static final AgentService instance = AgentService._private();

  AgentLog? _logger;
  bool _running = false;
  Completer<void>? _stopCompleter;

  /// Indica se o agente está em execução
  bool get isRunning => _running;

  /// Define um logger opcional (UI ou console)
  void setLogger(AgentLog logger) => _logger = logger;

  /// Inicia o agente. Se já estiver em execução, não reinicia.
  Future<void> start({Duration interval = const Duration(seconds: 5)}) async {
    if (_running) {
      _logger?.call('AgentService: já em execução.');
      return;
    }
    _running = true;
    _stopCompleter = Completer<void>();
    _logger?.call('AgentService: iniciado em ${DateTime.now()}.');

    // Não bloqueia a UI — roda o loop assincronamente
    _runLoop(interval);
  }

  Future<void> _runLoop(Duration interval) async {
    while (_running) {
      try {
        // ---- AQUI: chame suas rotinas reais (coleta tráfego, IA, QoS) ----
        // Exemplo: await IaNetworkService.instance.collectOnce();
        _logger?.call('AgentService: ciclo executado em ${DateTime.now()}.');
        // ----------------------------------------------------------------
      } catch (e, s) {
        _logger?.call('AgentService: erro no ciclo: $e\n$s');
      }

      // Aguarda o intervalo ou a requisição de parada
      await Future.any([
        Future.delayed(interval),
        _stopCompleter!.future,
      ]);
    }

    _logger?.call('AgentService: loop finalizado.');
  }

  /// Solicita parada e aguarda término do loop.
  Future<void> stop() async {
    if (!_running) {
      _logger?.call('AgentService: já parado.');
      return;
    }
    _running = false;
    _stopCompleter?.complete();
    // Aguarda um curto período para o loop encerrar tarefas pendentes
    await Future.delayed(const Duration(milliseconds: 150));
    _logger?.call('AgentService: parado em ${DateTime.now()}.');
  }

  /// Encerramento definitivo / liberar recursos
  Future<void> dispose() async {
    await stop();
    _logger = null;
  }
}
