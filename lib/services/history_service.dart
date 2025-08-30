// lib/services/ia_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'logger_service.dart';

class IaService {
  static final IaService _instance = IaService._internal();
  factory IaService() => _instance;
  IaService._internal();

  final LoggerService _logger = LoggerService();

  // Configurações de IA
  String localModelPath = "assets/ia/local_model.json"; // Exemplo de IA local
  String apiEndpoint = "https://api.suaia.com/process"; // Exemplo de IA remota
  String apiKey = "SUA_API_KEY_AQUI";

  // Processa um log
  Future<void> processLog(String logLine) async {
    await _logger.debug("IA: Processando log...");

    // Primeiro tenta IA local
    final localDecision = await _processLocal(logLine);
    if (localDecision != null) {
      await _applyDecision(localDecision);
      return;
    }

    // Se IA local não resolver, envia para API
    final apiDecision = await _processApi(logLine);
    if (apiDecision != null) {
      await _applyDecision(apiDecision);
    }
  }

  // IA local (exemplo simples: lê um JSON de padrões)
  Future<String?> _processLocal(String logLine) async {
    // Aqui você poderia ler o arquivo localModelPath e buscar padrões
    // Exemplo simplificado:
    if (logLine.contains("ERRO")) {
      return "ALERTA: Verificar erro no log";
    }
    return null;
  }

  // IA via API
  Future<String?> _processApi(String logLine) async {
    try {
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({"log": logLine}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['action'] ?? null;
      } else {
        await _logger.debug(
            "IA: Erro na API ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      await _logger.debug("IA: Exceção na API - $e");
      return null;
    }
  }

  // Aplica a decisão da IA
  Future<void> _applyDecision(String decision) async {
    await _logger.log("IA decidiu: $decision");
    // Aqui você pode adicionar ações automáticas, ex:
    // - Bloquear dispositivos suspeitos
    // - Ajustar configurações
    // - Notificar usuário
  }

  // Processa todos os logs existentes
  Future<void> processAllLogs() async {
    final logs = await _logger.readLogs();
    for (var log in logs) {
      await processLog(log);
    }
  }
}
