// lib/services/auth_service.dart
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Autenticação biométrica do usuário
  Future<bool> authenticate() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Autentique-se para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true, // mantém a sessão caso mude de app
          useErrorDialogs: true,
          biometricOnly: false, // permite fallback se necessário
        ),
      );

      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
