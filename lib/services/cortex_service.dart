// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 cortex_service.dart - Monitoramento inteligente de tráfego e priorização ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:async';

import 'device_model.dart';
import 'router_service.dart';
import 'notification_service.dart';

typedef VoiceCallback = void Function(String msg);

class CortexService {
  final RouterService routerService;
  final NotificationService notificationService;
  final VoiceCallback voiceCallback;

  List<DeviceModel> devices = [];
  Map<String, List<double>> trafficHistory = {};
  Map<String, String> deviceUsageType = {};

  Timer? _monitorTimer;

  CortexService({
    required this.routerService,
    required this.notificationService,
    required this.voiceCallback,
  });

  void startMonitoring({int intervalSeconds = 5}) {
    _monitorTimer?.cancel();

    _monitorTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) async {
        await _updateDevices();
        _analyzeTraffic();
      },
    );
  }

  void stopMonitoring() {
    _monitorTimer?.cancel();
  }

  Future<void> _updateDevices() async {
    devices = await routerService.getConnectedDevices();

    for (final DeviceModel device in devices) {
      trafficHistory[device.ip] ??= [];

      final double mbps = await routerService.getDeviceTraffic(device.mac);
      trafficHistory[device.ip]?.add(mbps);

      if (trafficHistory[device.ip]!.length > 10) {
        trafficHistory[device.ip]!.removeAt(0);
      }
    }
  }

  void _analyzeTraffic() {
    for (final DeviceModel device in devices) {
      final double currentMbps = trafficHistory[device.ip]?.last ?? 0;
      final String usageType = deviceUsageType[device.ip] ?? device.type;

      if (device.type.contains('Desconhecido')) {
        _notify('Dispositivo suspeito detectado: ${device.name}');
      }

      if (usageType.contains('TV') && currentMbps > 20) {
        final DeviceModel gameDevice = devices.firstWhere(
          (d) => d.type.contains('Console') || d.type.contains('PC'),
          orElse: () => DeviceModel(
            ip: '',
            mac: '',
            manufacturer: '',
            type: '',
            name: '',
          ),
        );

        if (gameDevice.ip.isNotEmpty) {
          voiceCallback(
            'TV ${device.name} está usando $currentMbps Mbps. Priorizando ${gameDevice.name}.',
          );
          _prioritizeDevice(gameDevice);
        }
      }
    }
  }

  void _prioritizeDevice(DeviceModel device, {int priority = 200}) {
    routerService.prioritizeDevice(device.mac, priority: priority);
    _notify('Dispositivo ${device.name} priorizado com QoS $priority.');
  }

  void _notify(String msg) {
    voiceCallback(msg);
    notificationService.showNotification('C.O.R.T.E.X.', msg);
  }

  void setDeviceUsageType(String ip, String type) {
    deviceUsageType[ip] = type;
  }

  List<double> getTrafficHistory(String ip) {
    return trafficHistory[ip] ?? [];
  }

  void clearHistory() {
    trafficHistory.clear();
  }
}

// Sugestões
// - 🧩 Extrair `_analyzeTraffic()` em múltiplas funções para reduzir complexidade
// - 🛡️ Adicionar `try/catch` em `_updateDevices()` para capturar falhas de rede
// - 🔤 Criar enum para tipos de uso (`TV`, `Console`, `PC`, `Desconhecido`) para evitar erros de string
// - 📦 Adicionar stream ou callback para atualizações em tempo real
// - 🎨 Integrar com visualização gráfica do histórico de tráfego

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
