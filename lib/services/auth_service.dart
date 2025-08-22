import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> init() async {
    // Inicialização opcional
  }

  Future<bool> authenticate() async {
    try {
      bool canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;

      return await _auth.authenticate(
        localizedReason: 'Autentique-se para acessar o Observador',
        biometricOnly: true,
      );
    } catch (e) {
      return false;
    }
  }
}
