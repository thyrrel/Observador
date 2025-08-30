// lib/services/logger_service.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() => _instance;

  LoggerService._internal();

  late File _logFile;
  String get logFilePath => _logFile.path;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/observador_logs.txt');

    if (!_logFile.existsSync()) {
      await _logFile.create(recursive: true);
    }

    log('LoggerService: Inicializado.');
  }

  // Função principal de log
  Future<void> log(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final logLine = '[$timestamp] $message';
    print(logLine); // Saída no console

    await _logFile.writeAsString('$logLine\n', mode: FileMode.append);

    // Aqui você pode chamar a IA híbrida para processar o log
    // Ex.: await IaService().processLog(logLine);
  }

  // Limpa os logs
  Future<void> clearLogs() async {
    if (_logFile.existsSync()) {
      await _logFile.writeAsString('');
      log('LoggerService: Logs limpos.');
    }
  }

  // Lê todos os logs
  Future<List<String>> readLogs() async {
    if (_logFile.existsSync()) {
      return _logFile.readAsLines();
    }
    return [];
  }

  // Função de depuração rápida
  Future<void> debug(String message) async {
    await log('DEBUG: $message');
  }
}
