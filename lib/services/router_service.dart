import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';

class RouterService {
  static const _ip = '192.168.1.1';
  static const _user = 'admin';    // virá das credenciais VIP
  static const _pass = '1234';     // virá das credenciais VIP

  static Future<void> blockIP(String ip) async {
    final client = SSHClient(
      await SSHSocket.connect(_ip, 22),
      username: _user,
      onPasswordRequest: () => _pass,
    );

    // Exemplo OpenWRT/DD-WRT
    await client.run(
      'iptables -I FORWARD -s $ip -j DROP',
    );
    client.close();
  }

  static Future<void> unblockIP(String ip) async {
    final client = SSHClient(
      await SSHSocket.connect(_ip, 22),
      username: _user,
      onPasswordRequest: () => _pass,
    );
    await client.run(
      'iptables -D FORWARD -s $ip -j DROP',
    );
    client.close();
  }
}
