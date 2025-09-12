// /lib/providers/auth_provider.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🔐 AuthProvider - Gerencia autenticação e perfil ┃
// ┃ 👤 Login, logout, persistência e papel do usuário ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 🔑 Estado de autenticação
enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _username;
  String? _role; // Ex.: 'admin', 'user', etc.

  // 🔍 Getters públicos
  bool get isAuthenticated => _isAuthenticated;
  AuthStatus get status => _status;
  String? get username => _username;
  String? get role => _role;
  bool get isAdmin => _role == 'admin';

  AuthProvider() {
    _loadAuthState();
  }

  /// 🔐 Login com username/password ou token biométrico
  Future<bool> login({
    required String username,
    required String password,
    String? role,
    bool saveSecure = true,
  }) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    // Validação simulada (substituir por backend real)
    final success = username.isNotEmpty && password.isNotEmpty;

    if (success) {
      _isAuthenticated = true;
      _username = username;
      _role = role ?? 'user';
      _status = AuthStatus.authenticated;

      if (saveSecure) {
        await _storage.write(key: 'auth_username', value: _username);
        await _storage.write(key: 'auth_role', value: _role);
        await _storage.write(key: 'auth_status', value: _status.toString());
      }
    } else {
      _isAuthenticated = false;
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
    return success;
  }

  /// 🔓 Logout e limpeza de dados persistidos
  Future<void> logout() async {
    _isAuthenticated = false;
    _username = null;
    _role = null;
    _status = AuthStatus.unauthenticated;

    await _storage.delete(key: 'auth_username');
    await _storage.delete(key: 'auth_role');
    await _storage.delete(key: 'auth_status');

    notifyListeners();
  }

  /// 📦 Carrega estado salvo no armazenamento seguro
  Future<void> _loadAuthState() async {
    try {
      final savedUsername = await _storage.read(key: 'auth_username');
      final savedRole = await _storage.read(key: 'auth_role');
      final savedStatus = await _storage.read(key: 'auth_status');

      final isValid = savedUsername != null &&
                      savedRole != null &&
                      savedStatus == AuthStatus.authenticated.toString();

      if (isValid) {
        _username = savedUsername;
        _role = savedRole;
        _isAuthenticated = true;
        _status = AuthStatus.authenticated;
      } else {
        _isAuthenticated = false;
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _isAuthenticated = false;
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }
}
