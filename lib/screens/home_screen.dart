import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/placeholder_service.dart';
import '../services/history_service.dart';
import '../services/ia_service.dart';
import '../widgets/device_list_widget.dart';
import '../widgets/notification_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final placeholderService = Provider.of<PlaceholderService>(context);
    final historyService = Provider.of<HistoryService>(context);
    final iaService = Provider.of<IAService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => themeService.cycleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await placeholderService.refreshPlaceholders();
              iaService.runDiagnostics();
              historyService.logEvent('Manual refresh triggered');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          NotificationWidget(
            notifications: historyService.recentEvents,
          ),
          Expanded(
            child: DeviceListWidget(
              placeholders: placeholderService.placeholders,
              onDeviceAction: (device, action) {
                iaService.analyzeDevice(device);
                historyService.logEvent('Action $action on ${device.name}');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          iaService.runBackgroundAnalysis();
          historyService.logEvent('Background analysis triggered');
        },
        child: const Icon(Icons.analytics),
      ),
    );
  }
}
