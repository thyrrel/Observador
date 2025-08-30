// lib/services/initializer.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'logger_service.dart';
import '../providers/app_state.dart';
import '../services/theme_service.dart';

class Initializer {
  static final Initializer _instance = Initializer._internal();

  factory Initializer() => _instance;

  Initializer._internal();

  final StorageService _storageService = StorageService();
  final LoggerService _logger = LoggerService();
  final AppState _appState = AppState();
  final ThemeService _themeService = ThemeService();

  // Inicialização completa do app
  Future<void> initializeApp() async {
    await _storageService.init();
    await _logger.init();
    await _appState.init();
    await _themeService.init();

    // Inicialização IA híbrida (local + API)
    await _initializeIA();

    // Inicialização de módulos adicionais
    await _initializeModules();

    // Observação de logs para depuração automática
    _watchLogs();

    _logger.log('Initializer: Todos os serviços carregados com sucesso.');
  }

  // Placeholder IA híbrida
  Future<void> _initializeIA() async {
    _logger.log('Inicializando IA híbrida (local + API)...');
    // Ex.: carregar modelos locais + configurar API
    // await IaService().init();
  }

  // Inicialização de módulos adicionais
  Future<void> _initializeModules() async {
    _logger.log('Inicializando módulos adicionais...');
    // Ex.: Monitoramento de dispositivos, placeholders, etc.
  }

  // Observa o arquivo de logs e atualiza estado/depuração automaticamente
  void _watchLogs() {
    final logFile = File(_logger.logFilePath);
    if (!logFile.existsSync()) return;

    logFile.watch().listen((event) async {
      if (event.type == FileSystemEvent.modify) {
        final lines = await logFile.readAsLines();
        final lastLine = lines.isNotEmpty ? lines.last : '';
        _logger.log('Novo log detectado: $lastLine');
        // Aqui você pode enviar para IA processar automaticamente
        // await IaService().processLog(lastLine);
      }
    });
  }

  // Getters globais para os serviços
  StorageService get storage => _storageService;
  LoggerService get logger => _logger;
  AppState get appState => _appState;
  ThemeService get theme => _themeService;
}
