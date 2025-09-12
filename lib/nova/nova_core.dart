// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 NovaCore - Núcleo da IA interna (N.O.V.A.)        ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/nova_snapshot.dart';
import '../services/logger_service.dart';

class NovaCore {
  final LoggerService logger = LoggerService();

  void observe(NovaSnapshot snapshot) {
    logger.log('NOVA: Observando ${snapshot.device.name} com ${snapshot.mbps.toStringAsFixed(2)} Mbps');

    if (snapshot.mbps > 25 && snapshot.usageType.contains('TV')) {
      logger.log('NOVA: Pico detectado na TV ${snapshot.device.name}');
      // TODO: gerar insight ou ação
    }

    // TODO: enviar para memória ou análise avançada
  }
}
