// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 NovaInsight - Representação de decisão da IA      ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../../../models/device_model.dart';

class NovaInsight {
  final DeviceModel device;
  final String tipo;         // Ex: 'Pico', 'Ociosidade', 'Suspeito'
  final String mensagem;     // Texto explicativo
  final DateTime timestamp;

  NovaInsight({
    required this.device,
    required this.tipo,
    required this.mensagem,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => '[$tipo] ${device.name}: $mensagem';
}
