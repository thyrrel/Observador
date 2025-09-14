// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 wifi_credentials_service.dart - Armazenamento de senhas de redes Wi-Fi ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class WifiCredentialsService {
  // Mapa de credenciais: SSID → senha
  final Map<String, String> _credentials = {};

  void saveCredentials(String ssid, String password) {
    _credentials[ssid] = password;
  }

  String? getPassword(String ssid) {
    return _credentials[ssid];
  }

  void removeCredentials(String ssid) {
    _credentials.remove(ssid);
  }

  List<String> get allSSIDs => _credentials.keys.toList();
}

// Sugestões
// - 🛡️ Criptografar senhas antes de armazenar, mesmo em memória
// - 🔤 Criar método `hasCredentials(String ssid)` para verificações rápidas
// - 📦 Integrar com persistência local (ex: Hive, SQLite, SharedPreferences)
// - 🧩 Adicionar suporte a múltiplos perfis por SSID (ex: convidado, admin)
// - 🎨 Expor stream para UI reativa com status de redes salvas

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
