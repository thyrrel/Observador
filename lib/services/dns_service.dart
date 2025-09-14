// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 dns_service.dart - Serviço de cache DNS local para resolução rápida ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class DNSService {
  final Map<String, String> _dnsCache = {};

  void setRecord(String hostname, String ip) {
    _dnsCache[hostname] = ip;
  }

  String? getRecord(String hostname) {
    return _dnsCache[hostname];
  }

  void clearCache() {
    _dnsCache.clear();
  }
}

// Sugestões
// - 🛡️ Adicionar verificação de formato para `hostname` e `ip` antes de armazenar
// - 🔤 Criar método `hasRecord(String hostname)` para facilitar consultas booleanas
// - 📦 Implementar persistência opcional do cache (ex: SQLite ou Hive)
// - 🧩 Adicionar TTL (Time To Live) para expiração automática de registros
// - 🎨 Expor stream ou callback para atualizações em tempo real (útil em UI reativa)

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
