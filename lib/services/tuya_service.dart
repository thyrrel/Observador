// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 tuya_service.dart - Gerenciador de dispositivos Tuya e seus tokens    ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class TuyaService {
  // Mapa de dispositivos: deviceId → token
  final Map<String, String> _devices = {};

  void addDevice(String deviceId, String token) {
    _devices[deviceId] = token;
  }

  void removeDevice(String deviceId) {
    _devices.remove(deviceId);
  }

  String? getToken(String deviceId) {
    return _devices[deviceId];
  }

  List<String> get allDevices => _devices.keys.toList();
}

// Sugestões
// - 🛡️ Validar formato do `deviceId` e `token` antes de salvar
// - 🔤 Criar método `hasDevice(String id)` para verificações rápidas
// - 📦 Integrar com persistência local (ex: Hive, SQLite) para manter estado
// - 🧩 Adicionar suporte a metadados (ex: nome, tipo, status de conexão)
– 🎨 Expor stream para UI reativa com lista de dispositivos conectados

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
