void analyzeTraffic(List<DeviceModel> devices, Map<String, double> usageMbps) {
  for (var d in devices) {
    double mbps = usageMbps[d.ip] ?? 0;

    if (mbps > 20 && d.type.contains("TV")) {
      _notifyVoice('A TV ${d.name} está consumindo $mbps Mbps. Deseja priorizar seu jogo?');
      // Sugestão automática: priorizar outro dispositivo (ex: console de jogo)
      _suggestQoS(d);
    }
  }
}

void _suggestQoS(DeviceModel tv) {
  // Simulação de sugestão para outro dispositivo
  DeviceModel? gameDevice = devices.firstWhere(
      (d) => d.type.contains("Console") || d.type.contains("PC"),
      orElse: () => DeviceModel(ip: '', mac: '', manufacturer: '', type: '', name: ''));
  if (gameDevice.ip != '') {
    _notifyVoice('Sugerindo priorizar ${gameDevice.name} para melhor performance.');
    // Integrar RouterService para aplicar QoS
    routerService.prioritizeDevice(gameDevice.mac, priority: 200);
  }
}
