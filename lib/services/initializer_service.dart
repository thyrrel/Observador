// lib/services/initializer_service.dart

import 'storage_service.dart';
import 'history_service.dart';
import 'logger_service.dart';

class Initializer {
  static final Initializer _instance = Initializer._internal();
  factory Initializer() => _instance;
  Initializer._internal();

  final StorageService _storage = StorageService();
  final HistoryService _history = HistoryService();
  final LoggerService _logger = LoggerService();

  /// Inicializa todo o sistema
  Future<void> init() async {
    _logger.log('Initializer: Iniciando inicialização completa.');

    // Inicializa StorageService
    await _storage.init();
    _logger.log('Initializer: StorageService inicializado.');

    // Inicializa HistoryService
    await _history.init();
    _logger.log('Initializer: HistoryService inicializado.');

    // Cria placeholders se não existirem
    await _createPlaceholder('theme', 'light'); // tema padrão: light
    await _createPlaceholder('user_settings', '{}');
    await _createPlaceholder('network_devices', '[]');

    _logger.log('Initializer: Placeholders criados ou verificados.');
    _logger.log('Initializer: Inicialização completa.');
  }

  /// Cria placeholder se não existir
  Future<void> _createPlaceholder(String key, String defaultValue) async {
    String? existing = await _storage.read(key);
    if (existing == null) {
      await _storage.write(key, defaultValue);
      _logger.log('Initializer: Placeholder criado -> $key = $defaultValue');
    } else {
      _logger.log('Initializer: Placeholder existente mantido -> $key = $existing');
    }
  }
}
