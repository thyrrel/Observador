import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();
      if (!canCheckBiometrics || !isDeviceSupported) return false;

      return await _auth.authenticate(
        localizedReason: 'Autentique-se para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
