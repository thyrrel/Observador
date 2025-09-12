// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 NovaCore - Núcleo da IA (N.O.V.A.)                ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'services/logger_service.dart';
import 'services/nova_analyzer_service.dart';
import 'services/nova_memory_service.dart';
import 'services/nova_action_service.dart';
import 'models/nova_snapshot.dart';
import '../../../models/device_model.dart';
import '../../../services/router_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef VoiceCallback = void Function(String msg);

class NovaCore {
  final LoggerService logger = LoggerService();
  final NovaAnalyzerService analyzer = NovaAnalyzerService();
  final NovaMemoryService memory = NovaMemoryService();
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

  // Processa snapshot completo
  void observe(NovaSnapshot snapshot) {
    logger.log('NOVA: Snapshot recebido de ${snapshot.device.name}');
    memory.storeSnapshot(snapshot);

    final insight = analyzer.analyze(snapshot);
    if (insight.isNotEmpty) {
      logger.log('NOVA: $insight');
      memory.rememberInsight(snapshot.device.ip, insight);

      // Ações baseadas em insight
      if (insight.contains('priorizado')) {
        action.prioritize(snapshot.device);
      }

      if (insight.contains('bloqueado')) {
        action.block(snapshot.device);
      }

      // TODO: expandir com regras dinâmicas
    }
  }
}
