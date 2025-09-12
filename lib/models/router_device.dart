// /lib/models/router_device.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 RouterDevice - Dispositivo bruto vindo do roteador ┃
// ┃ 🔍 MAC, nome, tráfego, tipo, sinal, fabricante etc ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class RouterDevice {
  final String mac;
  final String name;
  final int rxBytes;
  final int txBytes;
  final bool blocked;

  final String? ip;
  final String? manufacturer;
  final String? type;
  final int? signalStrength; // dBm
  final int? priorityLevel;
  final DateTime? lastSeen;

  RouterDevice({
    required this.mac,
    required this.name,
    required this.rxBytes,
    required this.txBytes,
    required this.blocked,
    this.ip,
    this.manufacturer,
    this.type,
    this.signalStrength,
    this.priorityLevel,
    this.lastSeen,
  });

  /// 🧬 Criação a partir de JSON genérico
  factory RouterDevice.fromJson(Map<String, dynamic> json) {
    return RouterDevice(
      mac: (json['mac'] ?? json['hwaddr'] ?? '').toString(),
      name: (json['name'] ?? json['hostname'] ?? '').toString(),
      rxBytes: _toInt(json['rx_bytes'] ?? json['rx']),
      txBytes: _toInt(json['tx_bytes'] ?? json['tx']),
      blocked: json['blocked'] == true || json['status'] == 'blocked',
      ip: json['ip']?.toString(),
      manufacturer: json['manufacturer']?.toString(),
      type: json['type']?.toString(),
      signalStrength: _toInt(json['signal'] ?? json['rssi']),
      priorityLevel: _toInt(json['priority']),
      lastSeen: _parseDate(json['last_seen']),
    );
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is double) return v.toInt();
    return 0;
  }

  static DateTime? _parseDate(dynamic v) {
    if (v is String) {
      try {
        return DateTime.tryParse(v);
      } catch (_) {}
    }
    return null;
  }
}
