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
}
