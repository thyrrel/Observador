// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🔍 MeshDiscoveryService - Descobre nós na rede       ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:async';
import 'dart:io';

typedef NodeFoundCallback = void Function(String ip);

class MeshDiscoveryService {
  NodeFoundCallback? onNodeFound;
  late RawDatagramSocket _socket;
  bool _running = false;

  final int port = 40404;
  final String pingMessage = 'NOVA_PING';

  // Inicia descoberta via broadcast
  void startDiscovery() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    _socket.broadcastEnabled = true;
    _running = true;

    Timer.periodic(Duration(seconds: 5), (timer) {
      if (!_running) timer.cancel();
      _broadcastPing();
    });

    _socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket.receive();
        if (datagram == null) return;

        final msg = String.fromCharCodes(datagram.data);
        final ip = datagram.address.address;

        if (msg == pingMessage && onNodeFound != null) {
          onNodeFound!(ip);
        }
      }
    });
  }

  // Envia ping via broadcast
  void _broadcastPing() {
    final data = pingMessage.codeUnits;
    _socket.send(data, InternetAddress('255.255.255.255'), port);
  }

  // Finaliza descoberta
  void stop() {
    _running = false;
    _socket.close();
  }
}
