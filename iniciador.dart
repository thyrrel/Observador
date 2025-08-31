// File: lib/iniciador.dart
import 'package:flutter/material.dart';
import 'package:observador/services/storage_service.dart';
import 'package:observador/services/theme_service.dart';
import 'package:observador/services/notification_service.dart';
import 'package:observador/services/device_service.dart';
import 'package:observador/services/remote_ai_service.dart';
import 'package:observador/services/history_service.dart';
import 'package:observador/providers/network_provider.dart';
import 'package:observador/widgets/device_tile.dart';
import 'package:observador/screens/main_screen.dart';

/// Inicializador do Projeto Observador
class Iniciador {
  static final Iniciador _instance = Iniciador._internal();
  factory Iniciador() => _instance;

  late StorageService storageService;
  late ThemeService themeService;
  late NotificationService notificationService;
  late DeviceService deviceService;
  late RemoteAIService remoteAIService;
  late HistoryService historyService;
  late NetworkProvider networkProvider;

  Iniciador._internal() {
    _initServices();
  }

  /// Inicializa todos os serviços essenciais
  void _initServices() {
    // Serviços básicos
    storageService = StorageService();
    themeService = ThemeService();
    notificationService = NotificationService();

    // Serviços de dados e IA
    deviceService = DeviceService(storageService: storageService);
    remoteAIService = RemoteAIService(storageService: storageService);
    historyService = HistoryService(storageService: storageService);

    // Provider de rede
    networkProvider = NetworkProvider(deviceService: deviceService);

    // Inicializa notificações
    notificationService.init();

    // Inicializa temas
    themeService.initThemes();

    // Inicializa logs e histórico
    historyService.initHistory();
  }

  /// Função para verificar e criar placeholders caso algum arquivo/função falte
  void checkAndCreatePlaceholders() {
    // Placeholder para DeviceService
    deviceService ??= DeviceService(storageService: storageService);

    // Placeholder para RemoteAIService
    remoteAIService ??= RemoteAIService(storageService: storageService);

    // Placeholder para ThemeService
    themeService ??= ThemeService();

    // Placeholder para NotificationService
    notificationService ??= NotificationService();
  }

  /// Inicializa o app
  void runAppWithInit() {
    checkAndCreatePlaceholders();

    runApp(MaterialApp(
      title: 'Observador',
      theme: themeService.getTheme('claro'),
      darkTheme: themeService.getTheme('escuro'),
      home: MainScreen(networkProvider: networkProvider),
    ));
  }
}
