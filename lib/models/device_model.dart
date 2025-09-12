// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 DeviceModel - Modelo de dispositivo       ┃
// ┃ 🔧 Representa um nó na rede observada        ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class DeviceModel {
  final String id;     // Identificador único
  final String name;   // Nome do dispositivo
  final String ip;     // Endereço IP
  final String mac;    // Endereço MAC

  DeviceModel({
    required this.id,
    required this.name,
    required this.ip,
    required this.mac,
  });
}
