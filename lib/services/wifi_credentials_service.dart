// lib/services/wifi_credentials_service.dart
class WifiCredentialsService {
  final Map<String, String> _credentials = {}; // SSID -> password

  void saveCredentials(String ssid, String password) {
    _credentials[ssid] = password;
  }

  String? getPassword(String ssid) => _credentials[ssid];

  void removeCredentials(String ssid) {
    _credentials.remove(ssid);
  }

  List<String> get allSSIDs => _credentials.keys.toList();
}
