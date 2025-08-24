// lib/services/auth_service.dart
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Autentique-se para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true, // Permite reautenticação
          // biometricOnly: true, // Removido para compatibilidade
        ),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
