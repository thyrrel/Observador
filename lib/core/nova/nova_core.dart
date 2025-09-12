// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 NovaCore - Núcleo da IA (N.O.V.A.)                ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'services/logger_service.dart';
import 'services/nova_analyzer_service.dart';
import 'models/nova_snapshot.dart';

class NovaCore {
  final LoggerService logger = LoggerService();
  final NovaAnalyzerService analyzer = NovaAnalyzerService();

  // Recebe snapshot e processa observação
  void observe(NovaSnapshot snapshot) {
    logger.log('NOVA: Snapshot recebido de ${snapshot.device.name}');

    // Interpreta snapshot
    final insight = analyzer.analyze(snapshot);

    // Registra insight se relevante
    if (insight.isNotEmpty) {
      logger.log('NOVA: $insight');
      // TODO: enviar para memória ou gerar ação
    }
  }
}
