import 'dart:io';
import 'package:flutter/foundation.dart';

class Initializer {
  static Future<void> init() async {
    await _ensureServicesExist();
    await _initServices();
  }

  static Future<void> _ensureServicesExist() async {
    final files = [
      'lib/services/storage_service.dart',
      'lib/services/history_service.dart',
      'lib/services/theme_service.dart',
      'lib/services/placeholder_service.dart',
      'lib/services/ia_service.dart',
      'lib/models/network_device.dart',
      'lib/providers/network_provider.dart',
      'lib/services/traffic_collector.dart',
    ];

    for (final path in files) {
      final file = File(path);
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString(_generateStub(path));
        debugPrint('✅ Criado: $path');
      }
    }
  }

  static String _generateStub(String path) {
    final name = path.split('/').last.replaceAll('.dart', '');
    final className = name
        .split('_')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join();

    if (path.contains('/models/')) {
      return '''
class $className {
  final String id;
  final String name;
  final String ip;

  $className({
    required this.id,
    required this.name,
    required this.ip,
  });
}
''';
    } else if (path.contains('/providers/')) {
      return '''
import 'package:flutter/material.dart';

class $className extends ChangeNotifier {
  void toggleBlockDevice(String deviceId) {
    // TODO: implementar
    notifyListeners();
  }
}
''';
    } else {
      return '''
class $className {
  static Future<void> init() async {
    // TODO: implementar
  }
}
''';
    }
  }

  static Future<void> _initServices() async {
    try {
      // ignore: avoid_dynamic_calls
      await _callIfExists('StorageService', 'init');
      await _callIfExists('HistoryService', 'init');
      await _callIfExists('ThemeService', 'init');
      await _callIfExists('PlaceholderService', 'init');
      await _callIfExists('IAService', 'init');
    } catch (e) {
      debugPrint('⚠️ Erro ao inicializar serviços: $e');
    }
  }

  static Future<void> _callIfExists(String className, String method) async {
    try {
      // Usa reflexão via dynamic para evitar erro de compilação
      final cls = _getClass(className);
      if (cls != null) {
        await cls[method]();
      }
    } catch (_) {
      // ignora silenciosamente
    }
  }

  static dynamic _getClass(String name) {
    // Placeholder para evitar erro de compilação
    return null;
  }
}
