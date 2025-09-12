// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🔍 NovaAnalyzerService - Interpretação de snapshots ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/nova_snapshot.dart';

class NovaAnalyzerService {
  // Analisa snapshot e retorna insight textual
  String analyze(NovaSnapshot snapshot) {
    final mbps = snapshot.mbps;
    final tipo = snapshot.usageType;
    final nome = snapshot.device.name;

    // Regra 1: pico de uso em TVs
    if (tipo.contains('TV') && mbps > 25) {
      return 'TV ${nome} está em pico de uso (${mbps.toStringAsFixed(2)} Mbps)';
    }

    // Regra 2: dispositivo ocioso
    if (mbps < 0.5 && snapshot.history.length >= 5) {
      final media = snapshot.history.reduce((a, b) => a + b) / snapshot.history.length;
      if (media < 0.5) return '${nome} está ocioso há um tempo';
    }

    // Regra 3: comportamento suspeito
    if (tipo.contains('Desconhecido') && mbps > 10) {
      return 'Dispositivo desconhecido ${nome} está ativo com ${mbps.toStringAsFixed(2)} Mbps';
    }

    // Sem insight relevante
    return '';
  }
}
