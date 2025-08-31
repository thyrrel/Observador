// File: lib/services/initializer.dart
import 'storage_service.dart';
import 'theme_service.dart';
import 'notification_service.dart';
import 'device_service.dart';
import 'remote_ai_service.dart';
import 'history_service.dart';
import '../../providers/network_provider.dart';

/// Verifica e corrige serviços e placeholders
class Initializer {
  static final Initializer _instance = Initializer._internal();
  factory Initializer() => _instance;

  Initializer._internal();

  void checkAndFix(Map<String, dynamic> services) {
    services['storageService'] ??= StorageService();
    services['themeService'] ??= ThemeService();
    services['notificationService'] ??= NotificationService();
    services['deviceService'] ??= DeviceService(storageService: services['storageService']);
    services['remoteAIService'] ??= RemoteAIService(storageService: services['storageService']);
    services['historyService'] ??= HistoryService(storageService: services['storageService']);
    services['networkProvider'] ??= NetworkProvider(deviceService: services['deviceService']);

    // Inicializações adicionais de segurança e placeholders
    services['notificationService'].init();
    services['themeService'].initThemes();
    services['historyService'].initHistory();
  }
}
