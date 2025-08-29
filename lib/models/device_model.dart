// [Flutter] lib/models/device_model.dart
// Modelo de dispositivo conectado ao roteador

class RouterDevice {
  final String mac;
  final String name;
  final int rxBytes; // bytes recebidos
  final int txBytes; // bytes enviados
  final bool blocked; // se está bloqueado

  RouterDevice({
    required this.mac,
    required this.name,
    this.rxBytes = 0,
    this.txBytes = 0,
    this.blocked = false,
  });

  RouterDevice copyWith({
    String? mac,
    String? name,
    int? rxBytes,
    int? txBytes,
    bool? blocked,
  }) {
    return RouterDevice(
      mac: mac ?? this.mac,
      name: name ?? this.name,
      rxBytes: rxBytes ?? this.rxBytes,
      txBytes: txBytes ?? this.txBytes,
      blocked: blocked ?? this.blocked,
    );
  }

  factory RouterDevice.fromJson(Map<String, dynamic> json) {
    return RouterDevice(
      mac: json['mac'] ?? json['hwaddr'] ?? '',
      name: json['name'] ?? json['hostname'] ?? json['host'] ?? '',
      rxBytes: json['rxBytes'] ?? json['rx_bytes'] ?? 0,
      txBytes: json['txBytes'] ?? json['tx_bytes'] ?? 0,
      blocked: json['blocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mac': mac,
      'name': name,
      'rxBytes': rxBytes,
      'txBytes': txBytes,
      'blocked': blocked,
    };
  }

  @override
  String toString() {
    return 'RouterDevice(mac: $mac, name: $name, rx: $rxBytes, tx: $txBytes, blocked: $blocked)';
  }
}
