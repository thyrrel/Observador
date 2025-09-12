// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 MeshCommService - Comunicação entre nós da malha ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:convert';
import 'dart:io';
import '../../models/nova_snapshot.dart';

typedef SnapshotCallback = void Function(NovaSnapshot snapshot);

class MeshCommService {
  final int port = 40405;
  final List<InternetAddress> _nodes = [];
  late RawDatagramSocket _socket;

  SnapshotCallback? onSnapshotReceived;

  // Inicia escuta de snapshots
  void listen() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    _socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket.receive();
        if (datagram == null) return;

        final msg = utf8.decode(datagram.data);
        final snapshot = NovaSnapshot.fromJson(jsonDecode(msg));
        if (onSnapshotReceived != null) onSnapshotReceived!(snapshot);
      }
    });
  }

  // Conecta a um novo nó
  void connectTo(String ip) {
    final address = InternetAddress(ip);
    if (!_nodes.contains(address)) _nodes.add(address);
  }

  // Envia snapshot para todos os nós conectados
  void sendToAll(NovaSnapshot snapshot) {
    final data = utf8.encode(jsonEncode(snapshot.toJson()));
    for (final node in _nodes) {
      _socket.send(data, node, port);
    }
  }

  // Finaliza comunicação
  void close() {
    _socket.close();
