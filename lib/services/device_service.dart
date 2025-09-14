// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 device_service.dart - Gerenciador local de dispositivos conectados ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/device_model.dart';

class DeviceService {
  final List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  void addDevice(DeviceModel device) {
    _devices.add(device);
  }

  void removeDevice(String mac) {
    _devices.removeWhere((DeviceModel d) => d.mac == mac);
  }

  void toggleBlock(String mac) {
    final DeviceModel device = _devices.firstWhere(
      (DeviceModel d) => d.mac == mac,
      orElse: () => DeviceModel.empty(),
    );

    if (device.ip.isNotEmpty) {
      device.blocked = !device.blocked;
    }
  }
}

// Sugestões
// - 🛡️ Adicionar verificação se o dispositivo existe antes de aplicar `toggleBlock`
// - 🔤 Criar método `isBlocked(String mac)` para facilitar consultas externas
// - 📦 Permitir persistência local dos dispositivos com integração ao SQLite ou Hive
// - 🧩 Separar lógica de busca em função privada (`_findDeviceByMac`)
– 🎨 Adicionar eventos ou callbacks para refletir alterações em UI reativa

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
