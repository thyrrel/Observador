// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 dashboard_service.dart - Serviço para agregação de dados de tráfego ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/device_model.dart';

class DashboardService {
  final List<DeviceModel> _devices = [];

  void updateDevices(List<DeviceModel> devices) {
    _devices.clear();
    _devices.addAll(devices);
  }

  List<DeviceModel> get devices => _devices;

  int get totalDevices => _devices.length;

  double get totalTrafficMbps {
    double total = 0;

    for (final DeviceModel device in _devices) {
      total += device.trafficMbps;
    }

    return total;
  }
}

// Sugestões
// - 🧩 Adicionar método `getAverageTraffic()` para média de Mbps por dispositivo
// - 🛡️ Validar se `trafficMbps` está sempre definido e não nulo
// - 🔤 Permitir filtragem por tipo de dispositivo (`TV`, `PC`, etc.) em métodos agregadores
// - 📦 Expor stream ou callback para atualizações em tempo real
// - 🎨 Integrar com visualização gráfica para dashboards interativos

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
