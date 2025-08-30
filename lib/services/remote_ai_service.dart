import 'api_handler.dart';
import 'logger_service.dart';

class RemoteAIService {
  final APIHandler apiHandler;
  final LoggerService logger = LoggerService();

  RemoteAIService(this.apiHandler);

  Future<void> analyzeLogsRemotely(List<String> logs) async {
    try {
      final result = await apiHandler.sendData({'logs': logs});
      logger.log('RemoteAI retornou: $result');
    } catch (e) {
      logger.log('Falha RemoteAI: $e');
    }
  }
}
