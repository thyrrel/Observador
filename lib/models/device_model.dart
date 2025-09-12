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

  // 🧬 Construtor a partir de JSON
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Dispositivo',
      ip: json['ip'] ?? '',
      mac: json['mac'] ?? '',
    );
  }

  // 📤 Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ip': ip,
      'mac': mac,
    };
  }

  // 🔁 Criar cópia modificada
  DeviceModel copyWith({
    String? id,
    String? name,
    String? ip,
    String? mac,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      mac: mac ?? this.mac,
    );
  }

  // 🧪 Comparação de objetos
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          ip == other.ip &&
          mac == other.mac;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ ip.hashCode ^ mac.hashCode;

  // 🧾 Representação textual
  @override
  String toString() {
    return 'DeviceModel(id: $id, name: $name, ip: $ip, mac: $mac)';
  }
}
