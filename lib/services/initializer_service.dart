// lib/services/initializer_service.dart

import 'dart:async';
import 'logger_service.dart';
import 'ia_service.dart';
import 'storage_service.dart';
import 'theme_service.dart';

class InitializerService {
  static final InitializerService _instance = InitializerService._internal();
  factory InitializerService() => _instance;
  InitializerService._internal();

  final LoggerService _logger = LoggerService();
  final IaService _ia = IaService();
  final StorageService _storage = StorageService();
  final ThemeService _theme = ThemeService();

  late StreamSubscription<String> _logSubscription;

  Future<void> initialize() async {
    // Inicializa armazenamento seguro
    await _storage.init();

    // Inicializa temas
    await _theme.init();

    // Inicializa Logger
    await _logger.init();

    // Inicializa IA
    await _ia.initialize();

    // Processa logs existentes
    final logs = await _logger.getAllLogs();
    for (var log in logs) {
      await _ia.processLog(log);
    }

    // Observa logs novos e envia automaticamente para IA
    _logSubscription = _logger.logStream.listen((logLine) async {
      await _ia.processLog(logLine);
    });

    await _logger.log("Initializer: Sistema inicializado com sucesso.");
  }

  // Função para alterar tema dinamicamente (mantendo todos os quatro)
  Future<void> setTheme(String themeName) async {
    if (_theme.availableThemes.contains(themeName)) {
      await _theme.setCurrentTheme(themeName);
      await _logger.log("Tema alterado para: $themeName");
    } else {
      await _logger.log("Tema inválido solicitado: $themeName");
    }
  }

  Future<void> dispose() async {
    await _logSubscription.cancel();
    await _logger.log("Initializer: Sistema finalizado.");
  }
}
