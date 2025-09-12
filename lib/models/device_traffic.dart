// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📊 DeviceTraffic - Estatísticas de tráfego   ┃
// ┃ 🔧 Dados de download e upload por dia        ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class DeviceTraffic {
  final String day;       // Dia da coleta (ex: '2025-09-11')
  final int rxBytes;      // Bytes recebidos (download)
  final int txBytes;      // Bytes enviados (upload)

  DeviceTraffic({
    required this.day,
    required this.rxBytes,
    required this.txBytes,
  });

  // 🧬 Construtor a partir de JSON
  factory DeviceTraffic.fromJson(Map<String, dynamic> json) {
    return DeviceTraffic(
      day: json['day'] ?? '',
      rxBytes: json['rxBytes'] ?? 0,
      txBytes: json['txBytes'] ?? 0,
    );
  }

  // 📤 Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'rxBytes': rxBytes,
      'txBytes': txBytes,
    };
  }

  // 🔁 Criar cópia modificada
  DeviceTraffic copyWith({
    String? day,
    int? rxBytes,
    int? txBytes,
  }) {
    return DeviceTraffic(
      day: day ?? this.day,
      rxBytes: rxBytes ?? this.rxBytes,
      txBytes: txBytes ?? this.txBytes,
    );
  }

  // 🧪 Comparação de objetos
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceTraffic &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          rxBytes == other.rxBytes &&
          txBytes == other.txBytes;

  @override
  int get hashCode =>
      day.hashCode ^ rxBytes.hashCode ^ txBytes.hashCode;

  // 🧾 Representação textual
  @override
  String toString() {
    return 'DeviceTraffic(day: $day, rxBytes: $rxBytes, txBytes: $txBytes)';
  }
}
