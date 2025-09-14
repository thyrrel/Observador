// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 traffic_collector_service.dart - Monitoramento simulado de tráfego de rede ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:async';

typedef TrafficCallback = void Function(Map<String, double> usageMbps);

class TrafficCollectorService {
  Timer? _timer;

  void startMonitoring(TrafficCallback callback, {int intervalSeconds = 5}) {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) {
        // 🧪 Simulação de coleta de tráfego
        final Map<String, double> mockData = {
          '192.168.0.2': 5.2,
          '192.168.0.3': 12.3,
        };
        callback(mockData);
      },
    );
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }
}

// Sugestões
// - 🛡️ Adicionar verificação se já está monitorando para evitar múltiplos timers
// - 🔤 Permitir configuração de IPs monitorados dinamicamente
// - 📦 Integrar com serviço de persistência para registrar histórico de tráfego
// - 🧩 Criar método `isMonitoring()` para controle externo
// - 🎨 Expor stream para UI reativa com gráficos em tempo real

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
