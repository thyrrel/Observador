// File: iniciador.dart
import 'package:flutter/material.dart';
import 'lib/services/initializer.dart';
import 'lib/services/storage_service.dart';
import 'lib/services/theme_service.dart';
import 'lib/services/notification_service.dart';
import 'lib/services/device_service.dart';
import 'lib/services/remote_ai_service.dart';
import 'lib/services/history_service.dart';
import 'lib/providers/network_provider.dart';
import 'lib/widgets/device_tile.dart';
import 'lib/screens/main_screen.dart';

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

  /// Inicializa o app e chama o initializer
  void runAppWithInit() async {
    runApp(MaterialApp(
      title: 'Observador',
      theme: themeService.getTheme('claro'),
      darkTheme: themeService.getTheme('escuro'),
      home: MainScreen(networkProvider: networkProvider),
    ));

    // Chama o Initializer depois que o app está em execução
    await Initializer().run(storageService, themeService, notificationService, deviceService, remoteAIService, historyService);
  }
}

void main() {
  Iniciador().runAppWithInit();
}
