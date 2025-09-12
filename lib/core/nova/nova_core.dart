// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 NovaCore - Núcleo da IA (N.O.V.A.)                ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'services/logger_service.dart';
import 'services/nova_analyzer_service.dart';
import 'services/nova_memory_service.dart';
import 'services/nova_action_service.dart';
import 'services/nova_insight_history_service.dart';
import 'models/nova_snapshot.dart';
import 'models/nova_insight.dart';
import '../../../models/device_model.dart';
import '../../../services/router_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef VoiceCallback = void Function(String msg);

class NovaCore {
  final LoggerService logger = LoggerService();
  final NovaAnalyzerService analyzer = NovaAnalyzerService();
  final NovaMemoryService memory = NovaMemoryService();
  final NovaInsightHistoryService history = NovaInsightHistoryService();
  late final NovaActionService action;

  NovaCore({
    required RouterService routerService,
    required VoiceCallback voiceCallback,
    required FlutterLocalNotificationsPlugin notificationsPlugin,
  }) {
    action = NovaActionService(
      routerService: routerService,
      voiceCallback: voiceCallback,
      notificationsPlugin: notificationsPlugin,
    );
  }

  // Entrada principal da IA: recebe snapshot e processa
  void observe(NovaSnapshot snapshot) {
    final ip = snapshot.device.ip;
    final nome = snapshot.device.name;

    logger.log('NOVA: Snapshot recebido de $nome');
    memory.storeSnapshot(snapshot);

    final NovaInsight? insight = analyzer.analyze(snapshot);
    if (insight == null) return;

    // Evita duplicidade de ação
    if (history.containsInsight(ip, insight.tipo)) {
      logger.log('NOVA: Insight já registrado para $nome (${insight.tipo})');
      return;
    }

    logger.log('NOVA: ${insight.toString()}');
    memory.rememberInsight(ip, insight.mensagem);
    history.add(insight);

    // Ações baseadas no tipo de insight
    switch (insight.tipo) {
      case 'Pico':
        action.prioritize(snapshot.device);
        break;
      case 'Suspeito':
        action.block(snapshot.device);
        break;
      // TODO: adicionar novos tipos (Ociosidade, Conflito, etc.)
    }
  }
}
