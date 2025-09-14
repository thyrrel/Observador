// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 biometric_auth_service.dart - Autenticação biométrica com fallback    ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Autentique-se para acessar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: true,
        ),
      );
    } catch (Object error) {
      // ⚠️ Falha na autenticação biométrica
      return false;
    }
  }
}

// Sugestões
// - 🛡️ Adicionar logging ou callback para capturar falhas de autenticação
// - 🔤 Permitir personalização da `localizedReason` via parâmetro
// - 📦 Expor método `canAuthenticate()` para uso externo antes de chamar `authenticate()`
// - 🧩 Separar verificação de suporte biométrico em função privada (`_isBiometricAvailable()`)
// - 🎨 Adicionar feedback visual em caso de falha silenciosa

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
