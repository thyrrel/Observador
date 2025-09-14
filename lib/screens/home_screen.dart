// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 home_screen.dart - Tela principal do app "Observador"       ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

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
    final ThemeService themeService = Provider.of<ThemeService>(context);
    final PlaceholderService placeholderService = Provider.of<PlaceholderService>(context);
    final HistoryService historyService = Provider.of<HistoryService>(context);
    final IAService iaService = Provider.of<IAService>(context);

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
              onDeviceAction: (Device device, String action) {
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

// Sugestões
// - 🧩 Extrair os botões do AppBar em widgets separados para reutilização
// - 🔤 Tipar explicitamente os parâmetros de `onDeviceAction` (feito)
// - 🧼 Usar `Consumer` ao invés de `Provider.of` para melhor performance e rebuild controlado
// - 📦 Adicionar tratamento para falhas em `refreshPlaceholders()`
// - 🛡️ Verificar se `device.name` pode ser nulo e aplicar fallback defensivo

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
