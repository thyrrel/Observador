import '../models/device_model.dart';
import 'router_service.dart';

typedef VoiceCallback = void Function(String msg);

class IAService {
  final VoiceCallback voiceCallback;
  final RouterService routerService;
  List<DeviceModel> devices = [];

  IAService({required this.voiceCallback, required this.routerService});

  /// Analisa todos os dispositivos de todos os roteadores
  Future<void> analyzeAllRouters() async {
    for (var routerIp in routerService.devicesByRouter.keys) {
      await analyzeDevices(routerIp);
      await analyzeTraffic(routerIp);
    }
  }

  /// Analisa dispositivos de um roteador específico
  Future<void> analyzeDevices(String routerIp) async {
    List<DeviceModel> devs = routerService.devicesByRouter[routerIp] ?? [];
    devices = devs;
    for (var d in devices) {
      if (d.type.contains('Desconhecido')) {
        voiceCallback('Dispositivo suspeito detectado no roteador $routerIp: ${d.name}');
      }
    }
  }

  /// Analisa tráfego real e aplica QoS baseado em hábitos
  Future<void> analyzeTraffic(String routerIp) async {
    List<DeviceModel> devs = routerService.devicesByRouter[routerIp] ?? [];
    Map<String, double> traffic = await routerService.getTraffic(routerIp);

    for (var d in devs) {
      double mbps = traffic[d.mac] ?? 0;

      // Exemplo: TV consumindo muita banda durante jogo
      if (mbps > 20 && d.type.contains('TV')) {
        voiceCallback('A TV ${d.name} está consumindo $mbps Mbps. Deseja priorizar o jogo?');
        _suggestQoS(d, routerIp);
      }

      // Monitoramento de hábitos do usuário
      _monitorHabits(d, mbps, routerIp);
    }
  }

  /// Sugere QoS priorizando dispositivos de acordo com uso
  void _suggestQoS(DeviceModel tv, String routerIp) {
    DeviceModel? gameDevice = devices.firstWhere(
        (d) => d.type.contains('Console') || d.type.contains('PC'),
        orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));

    if (gameDevice.ip != '') {
      voiceCallback('Sugerindo priorizar ${gameDevice.name}');
      routerService.prioritizeDevice(gameDevice.mac, priority: 200);
    }
  }

  /// Observa hábitos do usuário e aplica ações automáticas
  void _monitorHabits(DeviceModel dev, double mbps, String routerIp) {
    // Exemplo de antecipação:
    if (dev.name.toLowerCase().contains('ps5') && mbps < 5) {
      voiceCallback('Detectado início de jogo no ${dev.name}, direcionando banda automaticamente.');
      routerService.prioritizeDevice(dev.mac, priority: 250);
    }

    // Outros padrões e notificações podem ser adicionados aqui
  }

  /// Atualiza nome/tipo do dispositivo e mantém memória
  void updateDevice(String routerIp, String mac, {String? name, String? type}) {
    routerService.updateDevice(routerIp, mac, name: name, type: type);
  }
}
