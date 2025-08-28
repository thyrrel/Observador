// [Flutter] /lib/adapters/router_adapter.dart
abstract class RouterAdapter {
  /// Login no roteador, retorna token ou sessão
  Future<String?> login(String ip, String username, String password);

  /// Obtém lista de dispositivos conectados com RX/TX
  Future<List<RouterDevice>> getClients(String ip, String token);

  /// Bloqueia um dispositivo pelo MAC
  Future<bool> blockDevice(String ip, String token, String mac);

  /// Limita a velocidade de um dispositivo pelo MAC (em Mbps)
  Future<bool> limitDevice(String ip, String token, String mac, int limit);
}

class RouterDevice {
  final String mac;
  final String name;
  final int rxBytes;
  final int txBytes;
  final bool blocked;

  RouterDevice({
    required this.mac,
    required this.name,
    required this.rxBytes,
    required this.txBytes,
    required this.blocked,
  });
}
