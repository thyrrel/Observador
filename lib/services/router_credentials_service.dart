// lib/services/router_credentials_service.dart
class RouterCredentialsService {
  final Map<String, Map<String, String>> _credentials = {}; // IP -> {username, password}

  void saveCredentials(String ip, String username, String password) {
    _credentials[ip] = {'username': username, 'password': password};
  }

  Map<String, String>? getCredentials(String ip) => _credentials[ip];

  void removeCredentials(String ip) => _credentials.remove(ip);
}
