// /lib/providers/dns_provider.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🌐 DNSProvider - Gerencia DNS primário/secundário ┃
// ┃ 🔧 Atualização, reset e notificação reativa ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/foundation.dart';

class DNSProvider extends ChangeNotifier {
  String _primaryDNS = '8.8.8.8';
  String _secondaryDNS = '8.8.4.4';

  String get primaryDNS => _primaryDNS;
  String get secondaryDNS => _secondaryDNS;

  /// 📝 Atualiza o DNS primário
  void setPrimaryDNS(String dns) {
    _primaryDNS = dns;
    notifyListeners();
  }

  /// 📝 Atualiza o DNS secundário
  void setSecondaryDNS(String dns) {
    _secondaryDNS = dns;
    notifyListeners();
  }

  /// 🔄 Define ambos os DNS de uma vez
  void setDNS({required String primary, required String secondary}) {
    _primaryDNS = primary;
    _secondaryDNS = secondary;
    notifyListeners();
  }

  /// 🧹 Reseta para DNS padrão (Google)
  void resetDNS() {
    _primaryDNS = '8.8.8.8';
    _secondaryDNS = '8.8.4.4';
    notifyListeners();
  }
}
