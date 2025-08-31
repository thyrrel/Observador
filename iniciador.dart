// File: iniciador.dart
import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'services/device_service.dart';
import 'services/remote_ai_service.dart';
import 'services/history_service.dart';
import 'providers/network_provider.dart';
import 'widgets/device_tile.dart';
import 'screens/main_screen.dart';
import 'services/initializer.dart';

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
    _runInitializer();
  }

  void _initServices() {
    storageService = StorageService();
    themeService = ThemeService();
    notificationService = NotificationService();
    deviceService = DeviceService(storageService: storageService);
    remoteAIService = RemoteAIService(storageService: storageService);
    historyService = HistoryService(storageService: storageService);
    networkProvider = NetworkProvider(deviceService: deviceService);

    notificationService.init();
    themeService.initThemes();
    historyService.initHistory();
  }

  void _runInitializer() {
    Initializer().checkAndFix(_allServices());
  }

  Map<String, dynamic> _allServices() => {
        'storageService': storageService,
        'themeService': themeService,
        'notificationService': notificationService,
        'deviceService': deviceService,
        'remoteAIService': remoteAIService,
        'historyService': historyService,
        'networkProvider': networkProvider,
      };

  void runAppWithInit() {
    runApp(MaterialApp(
      title: 'Observador',
      theme: themeService.getTheme('claro'),
      darkTheme: themeService.getTheme('escuro'),
      home: MainScreen(networkProvider: networkProvider),
    ));
  }
}
