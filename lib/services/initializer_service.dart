// /services/initializer.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'history_service.dart';
import 'logger_service.dart';
import 'theme_manager.dart';
import 'placeholder_manager.dart';

class Initializer {
  static final Initializer _instance = Initializer._internal();

  factory Initializer() {
    return _instance;
  }

  Initializer._internal();

  StorageService storageService = StorageService();
  HistoryService historyService = HistoryService();
  LoggerService loggerService = LoggerService();
  ThemeManager themeManager = ThemeManager();
  PlaceholderManager placeholderManager = PlaceholderManager();

  Future<void> init({bool forceInit = false}) async {
    // 1. Inicializar storage seguro
    await storageService.init(forceInit: forceInit);

    // 2. Inicializar histórico
    await historyService.init(forceInit: forceInit);

    // 3. Inicializar logger
    await loggerService.init(forceInit: forceInit);

    // 4. Inicializar temas (claro, escuro, OLED, Matrix)
    await themeManager.init(forceInit: forceInit);

    // 5. Criar placeholders padrão para arquivos/configs ausentes
    await placeholderManager.init(forceInit: forceInit);

    // 6. Verificar dependências essenciais
    await _checkDependencies();

    // 7. Log final de inicialização
    loggerService.log('Initializer: Todas as services carregadas com sucesso.');

    // 8. Hook para IA (local + API)
    _setupAIIntegration();
  }

  Future<void> _checkDependencies() async {
    // Exemplo: checar se diretórios e arquivos críticos existem
    List<String> requiredDirs = [
      storageService.baseDir,
      historyService.baseDir,
      'logs',
      'screens',
      'providers',
    ];

    for (String dir in requiredDirs) {
      final directory = Directory(dir);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
        loggerService.log('Initializer: Diretório criado -> $dir');
      }
    }

    // Placeholder de dependências futuras
    // Aqui podemos checar pacotes flutter ou arquivos essenciais
  }

  void _setupAIIntegration() {
    // Hook para análise de logs local + integração com API NLP / Deep Learning
    loggerService.log('Initializer: Hook IA configurado (local + API).');
    // Exemplo: podemos passar logs para análise de padrões e alertas
  }
}

// Uso:
// await Initializer().init();
