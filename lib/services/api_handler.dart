// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 api_handler.dart - Classe para envio de dados via requisição HTTP ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHandler {
  final String endpoint;

  APIHandler(this.endpoint);

  Future<Map<String, dynamic>> sendData(Map<String, dynamic> data) async {
    final Uri uri = Uri.parse(endpoint);

    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Erro API: ${response.statusCode}');
    }
  }
}

// Sugestões
// - 🛡️ Adicionar tratamento com `try/catch` para falhas de rede ou parsing
// - 🔤 Validar se `response.body` é JSON antes de decodificar
// - 📦 Permitir configuração de headers adicionais via parâmetro opcional
// - 🧩 Extrair lógica de requisição para método privado (`_postRequest`)
// - 🧼 Adicionar logging ou callback para monitoramento de falhas

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
