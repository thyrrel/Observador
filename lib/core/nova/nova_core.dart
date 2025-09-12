// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 NovaCore - Núcleo da IA (Next-Gen Virtual Alg.)   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/nova_snapshot.dart';
import '../services/logger_service.dart';

class NovaCore {
  final LoggerService logger = LoggerService();

  // Recebe snapshot e processa observação
  void observe(NovaSnapshot snapshot) {
    logger.log('NOVA: Observando ${snapshot.device.name} com ${snapshot.mbps.toStringAsFixed(2)} Mbps');

    // Regra simples: detectar pico em TVs
    if (snapshot.mbps > 25 && snapshot.usageType.contains('TV')) {
      logger.log('NOVA: Pico detectado na TV ${snapshot.device.name}');
      // TODO: gerar insight ou ação
    }

    // TODO: enviar para memória ou análise avançada
  }
}
