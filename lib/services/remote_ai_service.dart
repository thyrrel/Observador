import 'api_handler.dart';
import 'logger_service.dart';
import 'storage_service.dart';

class RemoteAIService {
  final APIHandler apiHandler;
  final StorageService storageService;
  final LoggerService logger = LoggerService();

  RemoteAIService({
    required this.apiHandler,
    required this.storageService,
  });

  Future<void> analyzeLogsRemotely(List<String> logs) async {
    try {
      final result = await apiHandler.sendData({'logs': logs});
      logger.log('RemoteAI retornou: $result');
    } catch (e) {
      logger.log('Falha RemoteAI: $e');
    }
  }
}
