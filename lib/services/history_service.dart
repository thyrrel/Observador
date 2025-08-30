// lib/services/history_service.dart
import 'dart:convert';
import 'storage_service.dart';
import 'logger_service.dart';

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  final StorageService _storage = StorageService();
  final LoggerService _logger = LoggerService();

  final String _historyKey = 'history';

  /// Inicializa o histórico, criando chave se não existir
  Future<void> init() async {
    await _storage.init();
    String? existing = await _storage.read(_historyKey);
    if (existing == null || existing.isEmpty) {
      await _storage.write(_historyKey, jsonEncode([]));
      _logger.log('HistoryService: Histórico inicializado.');
    } else {
      _logger.log('HistoryService: Histórico existente carregado.');
    }
  }

  /// Adiciona um item ao histórico
  Future<void> addEntry(Map<String, dynamic> entry) async {
    List<dynamic> current = await getAll();
    current.add(entry);
    await _storage.write(_historyKey, jsonEncode(current));
    _logger.log('HistoryService: Entrada adicionada -> $entry');
  }

  /// Retorna todas as entradas do histórico
  Future<List<dynamic>> getAll() async {
    String? data = await _storage.read(_historyKey);
    if (data == null || data.isEmpty) return [];
    try {
      return jsonDecode(data);
    } catch (e) {
      _logger.log('HistoryService: Erro ao decodificar histórico -> $e');
      return [];
    }
  }

  /// Limpa o histórico
  Future<void> clear() async {
    await _storage.write(_historyKey, jsonEncode([]));
    _logger.log('HistoryService: Histórico limpo.');
  }

  /// Remove uma entrada específica pelo índice
  Future<void> removeAt(int index) async {
    List<dynamic> current = await getAll();
    if (index >= 0 && index < current.length) {
      var removed = current.removeAt(index);
      await _storage.write(_historyKey, jsonEncode(current));
      _logger.log('HistoryService: Entrada removida -> $removed');
    } else {
      _logger.log('HistoryService: Tentativa de remover índice inválido -> $index');
    }
  }
}
