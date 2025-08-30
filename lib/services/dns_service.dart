// lib/services/dns_service.dart
class DNSService {
  final Map<String, String> _dnsCache = {};

  void setRecord(String hostname, String ip) {
    _dnsCache[hostname] = ip;
  }

  String? getRecord(String hostname) => _dnsCache[hostname];

  void clearCache() => _dnsCache.clear();
}
