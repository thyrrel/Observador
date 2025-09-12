// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 NetworkDevice - Representação de rede     ┃
// ┃ 🔧 Modelo para dispositivos monitorados      ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class NetworkDevice {
  final String id;        // Identificador único
  String name;            // Nome do dispositivo
  String ip;              // Endereço IP
  bool blocked;           // Status de bloqueio

  NetworkDevice({
    required this.id,
    required this.name,
    required this.ip,
    this.blocked = false,
  });
}
