// /lib/core/routes.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧭 Routes - Navegação principal do app       ┃
// ┃ 🔧 Inclui DevToolsPage para testes/debug     ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import '../pages/device_list_page.dart';
import '../pages/device_details_page.dart';
import '../pages/devtools_page.dart'; // 👈 Importa DevTools

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/': (context) => const DeviceListPage(),
    '/details': (context) => const DeviceDetailsPage(),
    '/devtools': (context) => const DevToolsPage(), // 👈 Rota de debug
  };
}
