// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 network_service.dart - Gerenciador de dispositivos na rede local     ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/device_model.dart';

class NetworkService {
  final List<DeviceModel> _devices = [];
  bool loading = false;

  List<DeviceModel> get devices => _devices;

  Future<void> loadNetworkData() async {
    loading = true;
    await Future.delayed(const Duration(seconds: 1)); // 🕒 Simulação de fetch
    loading = false;
  }

  void addDevice(DeviceModel device) {
    _devices.add(device);
  }

  void removeDevice(String mac) {
    _devices.removeWhere((DeviceModel d) => d.mac == mac);
  }

  void toggleBlock(DeviceModel device) {
    device.blocked = !device.blocked;
  }
}

// Sugestões
// - 🛡️ Adicionar verificação para evitar duplicatas em `addDevice()`
// - 🔤 Criar método `findDevice(String mac)` para facilitar buscas
// - 📦 Expor stream ou callback para refletir mudanças em tempo real na UI
// - 🧩 Adicionar persistência local (ex: SQLite ou Hive) para manter estado
// - 🎨 Integrar com indicadores visuais de `loading` e `blocked` na interface

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
