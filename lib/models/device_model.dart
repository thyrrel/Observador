// /lib/models/device_model.dart

import 'router_device.dart'; // 💡 IMPORTAÇÃO ADICIONADA PARA RESOLVER O ERRO 'RouterDevice' isn't a type.
import 'dart:convert'; // Necessário para a conversão de/para String/DateTime em JSON

// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 DeviceModel - Representa um dispositivo na rede ┃
// ┃ 🔍 IP, MAC, tráfego, tipo, sinal, prioridade etc ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class DeviceModel {
  final String ip;
  final String mac;
  final String name;
  final String manufacturer;
  final String type;

  final int rxBytes;
  final int txBytes;
  final int signalStrength; // dBm (Wi-Fi)
  final int priorityLevel;  // 0 = normal, 1 = priorizado, 2 = crítico

  final DateTime? lastSeen;
  bool blocked;

  DeviceModel({
    required this.ip,
    required this.mac,
    required this.name,
    required this.manufacturer,
    required this.type,
    required this.rxBytes,
    required this.txBytes,
    this.signalStrength = 0,
    this.priorityLevel = 0,
    this.lastSeen,
    this.blocked = false,
  });
  
  // 💡 CORREÇÃO 1: Adição do método toJson() para serialização
  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'mac': mac,
      'name': name,
      'manufacturer': manufacturer,
      'type': type,
      'rxBytes': rxBytes,
      'txBytes': txBytes,
      'signalStrength': signalStrength,
      'priorityLevel': priorityLevel,
      'lastSeen': lastSeen?.toIso8601String(), // Converte DateTime para String
      'blocked': blocked,
    };
  }

  // 💡 CORREÇÃO 2: Adição do factory constructor fromJson() para desserialização
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      ip: json['ip'] as String,
      mac: json['mac'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String,
      type: json['type'] as String,
      rxBytes: json['rxBytes'] as int,
      txBytes: json['txBytes'] as int,
      // Propriedades com valores padrão/nulos para segurança na leitura
      signalStrength: json['signalStrength'] as int? ?? 0,
      priorityLevel: json['priorityLevel'] as int? ?? 0,
      lastSeen: json['lastSeen'] != null 
          ? DateTime.tryParse(json['lastSeen'] as String) 
          : null,
      blocked: json['blocked'] as bool? ?? false,
    );
  }


  /// 🧬 Cria a partir de RouterDevice
  factory DeviceModel.fromRouter(RouterDevice r) {
    return DeviceModel(
      ip: r.ip ?? '',
      mac: r.mac,
      name: r.name,
      manufacturer: r.manufacturer ?? '',
      type: r.type ?? 'Desconhecido',
      rxBytes: r.rxBytes,
      txBytes: r.txBytes,
      signalStrength: r.signalStrength ?? 0,
      priorityLevel: r.priorityLevel ?? 0,
      lastSeen: r.lastSeen,
      blocked: r.blocked,
    );
  }

  /// 🧼 Instância vazia
  factory DeviceModel.empty() => DeviceModel(
        ip: '',
        mac: '',
        name: '',
        manufacturer: '',
        type: '',
        rxBytes: 0,
        txBytes: 0,
      );

  /// 📊 Mbps atual estimado
  double get currentMbps => ((rxBytes + txBytes) * 8) / 1e6;

  /// 🔍 Identificador curto
  String get shortId => '${name.isNotEmpty ? name : mac.substring(0, 8)}';

  /// 🧠 Sugestão de uso baseado em tipo
  String get usageHint {
    if (type.contains('TV')) return 'Streaming';
    if (type.contains('Console')) return 'Jogos';
    if (type.contains('PC')) return 'Trabalho';
    if (type.contains('Celular')) return 'Pessoal';
    return 'Desconhecido';
  }

  /// 🔥 Está ativo?
  bool get isActive => rxBytes + txBytes > 0;
}
