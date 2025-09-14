// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 router_credentials_service.dart - Armazenamento seguro de credenciais  ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class RouterCredentialsService {
  // Mapa de credenciais: IP → {username, password}
  final Map<String, Map<String, String>> _credentials = {};

  void saveCredentials(String ip, String username, String password) {
    _credentials[ip] = {
      'username': username,
      'password': password,
    };
  }

  Map<String, String>? getCredentials(String ip) {
    return _credentials[ip];
  }

  void removeCredentials(String ip) {
    _credentials.remove(ip);
  }
}

// Sugestões
// - 🛡️ Criptografar senha antes de armazenar (mesmo em memória)
// - 🔤 Criar método `hasCredentials(String ip)` para verificações rápidas
// - 📦 Adicionar persistência com `SharedPreferences`, Hive ou SQLite
// - 🧩 Permitir múltiplos perfis por IP (ex: admin, guest, technician)
// - 🎨 Integrar com UI para exibir status de autenticação ou alertas

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
