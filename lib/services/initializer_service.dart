// File: lib/service/initializer.dart
import '../services/storage_service.dart';
import '../services/theme_service.dart';
import '../services/notification_service.dart';
import '../services/device_service.dart';
import '../services/remote_ai_service.dart';
import '../services/history_service.dart';
import '../providers/network_provider.dart';

class Initializer {
  void checkAndCreatePlaceholders({
    required StorageService storageService,
    required ThemeService themeService,
    required NotificationService notificationService,
    required DeviceService deviceService,
    required RemoteAIService remoteAIService,
    required HistoryService historyService,
    required NetworkProvider networkProvider,
  }) {
    deviceService ??= DeviceService(storageService: storageService);
    remoteAIService ??= RemoteAIService(storageService: storageService);
    themeService ??= ThemeService();
    notificationService ??= NotificationService();
    historyService ??= HistoryService(storageService: storageService);
    networkProvider ??= NetworkProvider(deviceService: deviceService);
  }
}
