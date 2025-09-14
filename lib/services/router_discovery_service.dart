// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 router_discovery_service.dart - Gerenciador de roteadores detectados ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/device_model.dart';

class RouterDiscoveryService {
  final List<DeviceModel> _routers = [];

  List<DeviceModel> get routers => _routers;

  void addRouter(DeviceModel router) {
    _routers.add(router);
  }

  void removeRouter(String ip) {
    _routers.removeWhere((DeviceModel r) => r.ip == ip);
  }
}

// Sugestões
// - 🛡️ Adicionar verificação para evitar duplicatas em `addRouter()`
// - 🔤 Criar método `findRouter(String ip)` para facilitar buscas
// - 📦 Integrar com persistência local (ex: Hive, SQLite) para manter estado
// - 🧩 Adicionar suporte a metadados (ex: modelo, fabricante, status de conexão)
// - 🎨 Expor stream ou callback para refletir mudanças em tempo real na UI

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
