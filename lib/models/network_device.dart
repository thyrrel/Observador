// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 NetworkDevice - Dispositivo monitorado    ┃
// ┃ 🔧 Histórico de tráfego e status de bloqueio ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'device_model.dart';
import 'device_traffic.dart';

class NetworkDevice {
  final RouterDevice device;                 // Dados básicos do dispositivo
  final List<DeviceTraffic> trafficHistory;  // Histórico de tráfego diário

  NetworkDevice({
    required this.device,
    List<DeviceTraffic>? trafficHistory,
  }) : trafficHistory = trafficHistory ?? [];

  // 📥 Total de bytes recebidos
  int get totalRx => trafficHistory.fold(0, (sum, t) => sum + t.rxBytes);

  // 📤 Total de bytes enviados
  int get totalTx => trafficHistory.fold(0, (sum, t) => sum + t.txBytes);

  // ➕ Adiciona novo registro de tráfego
  void addTraffic(DeviceTraffic t) {
    trafficHistory.add(t);
  }

  // 🚫 Verifica se o dispositivo está bloqueado
  bool get isBlocked => device.blocked;
}
