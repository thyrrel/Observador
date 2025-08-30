// lib/providers/auth_manager.dart
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class AuthManager extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  /// Método público para realizar login biométrico
  Future<bool> authenticate() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Autentique-se para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: false,
        ),
      );

      _isAuthenticated = didAuthenticate;
      notifyListeners();
      return didAuthenticate;
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      if (kDebugMode) {
        print('Erro na autenticação: $e');
      }
      return false;
    }
  }

  /// Logout manual
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Login manual (por senha ou fallback)
  void loginManually() {
    _isAuthenticated = true;
    notifyListeners();
  }
}
