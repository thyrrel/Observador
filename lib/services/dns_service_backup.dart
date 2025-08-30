import 'dart:convert';
import 'package:http/http.dart' as http;

class DNSService {
  Future<String?> resolveDoH(String domain) async {
    try {
      final response = await http.get(Uri.parse(
          'https://cloudflare-dns.com/dns-query?name=$domain&type=A'));

      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
