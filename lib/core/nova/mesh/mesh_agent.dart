// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🔗 MeshAgent - Nó da malha lógica da N.O.V.A.        ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:async';
import 'mesh_discovery_service.dart';
import 'mesh_comm_service.dart';
import '../../models/nova_snapshot.dart';

class MeshAgent {
  final MeshDiscoveryService discovery = MeshDiscoveryService();
  final MeshCommService comm = MeshCommService();

  final StreamController<NovaSnapshot> _snapshotStream = StreamController.broadcast();

  // Inicializa agente e começa descoberta
  void start() {
    discovery.onNodeFound = _handleNodeFound;
    discovery.startDiscovery();

    comm.onSnapshotReceived = _handleSnapshot;
    comm.listen();
  }

  // Envia snapshot para outros nós
  void broadcastSnapshot(NovaSnapshot snapshot) {
    comm.sendToAll(snapshot);
  }

  // Stream pública para o núcleo da IA
  Stream<NovaSnapshot> get snapshotStream => _snapshotStream.stream;

  // Quando um nó é encontrado
  void _handleNodeFound(String ip) {
    comm.connectTo(ip);
  }

  // Quando um snapshot é recebido
  void _handleSnapshot(NovaSnapshot snapshot) {
    _snapshotStream.add(snapshot);
  }

  // Finaliza agente
  void stop() {
    discovery.stop();
    comm.close();
    _snapshotStream.close();
  }
}
