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

    /// Define prioridade alta (ex.: para jogos)
static Future<void> setHighPriority(String ip) async {
  final client = SSHClient(
    await SSHSocket.connect(_ip, 22),
    username: _user,
    onPasswordRequest: () => _pass,
  );

  // Exemplo OpenWRT: marca pacote com DSCP 46 (Expedited Forwarding)
  await client.run(
    'iptables -t mangle -A POSTROUTING -s $ip -j DSCP --set-dscp 46',
  );
  client.close();
}

/// Limita banda para X kbit/s (ex.: 512 kbit/s)
static Future<void> limitIP(String ip, int kbit) async {
  final client = SSHClient(
    await SSHSocket.connect(_ip, 22),
    username: _user,
    onPasswordRequest: () => _pass,
  );

  // tc + HTB no OpenWRT
  await client.run(
    'tc class add dev br-lan parent 1: classid 1:10 htb rate ${kbit}kbit ceil ${kbit}kbit',
  );
  await client.run(
    'tc filter add dev br-lan protocol ip parent 1:0 prio 1 u32 match ip src $ip flowid 1:10',
  );
  client.close();
}

    
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
