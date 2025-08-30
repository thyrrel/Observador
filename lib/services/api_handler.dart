import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHandler {
  final String endpoint;
  APIHandler(this.endpoint);

  Future<Map<String, dynamic>> sendData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro API: ${response.statusCode}');
    }
  }
}
