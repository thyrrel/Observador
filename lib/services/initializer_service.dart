// /lib/initializer.dart

import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'services/history_service.dart';
import 'services/theme_service.dart';
import 'services/placeholder_service.dart';
import 'services/ia_service.dart';

class Initializer {
  final StorageService storageService = StorageService();
  final HistoryService historyService = HistoryService();
  final ThemeService themeService = ThemeService();
  final PlaceholderService placeholderService = PlaceholderService();
  final IAService iaService = IAService();

  /// Inicializa todos os serviços do app Observador
  Future<void> initializeApp() async {
    // Inicializa armazenamento seguro
    await storageService.init();

    // Inicializa placeholders (cria se não existirem)
    await placeholderService.initPlaceholders();

    // Inicializa temas (carrega tema salvo ou padrão)
    await themeService.loadThemes();

    // Inicializa histórico de eventos
    await historyService.init();

    // Inicializa IA híbrida (local + API)
    await iaService.init();

    // Exemplo de depuração: registra inicialização
    await historyService.logEvent("App inicializado com sucesso");

    debugPrint("🚀 Inicialização completa: todos os serviços carregados!");
  }

  /// Método para depuração automatizada
  Future<void> autoDebug() async {
    // Lê logs de histórico
    var logs = await historyService.getAllLogs();
    debugPrint("📄 Logs atuais:\n$logs");

    // Pode ajustar placeholders ou corrigir valores inválidos
    await placeholderService.verifyAndFixPlaceholders();

    // IA pode analisar logs e sugerir correções
    await iaService.analyzeLogs(logs);
  }
}
