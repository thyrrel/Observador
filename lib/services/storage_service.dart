import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logger_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LoggerService _logger = LoggerService();

  /// Inicializa o storage verificando se cada chave já existe
  Future<void> init() async {
    List<String> defaultKeys = ['theme', 'userToken', 'history', 'settings'];

    for (var key in defaultKeys) {
      String? value = await _secureStorage.read(key: key);
      if (value == null) {
        await _secureStorage.write(key: key, value: '');
        _logger.log('StorageService: Criada chave padrão -> $key');
      } else {
        _logger.log('StorageService: Chave já existe -> $key');
      }
    }
  }

  /// Lê o valor de uma chave
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Escreve um valor em uma chave
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    _logger.log('StorageService: Atualizado -> $key = $value');
  }

  /// Apaga uma chave específica
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
    _logger.log('StorageService: Chave deletada -> $key');
  }

  /// Limpa todo o storage
  Future<void> clear() async {
    await _secureStorage.deleteAll();
    _logger.log('StorageService: Storage limpo completamente');
  }
}
