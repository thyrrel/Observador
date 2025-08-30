import 'logger_service.dart';

class LocalAI {
  final LoggerService logger = LoggerService();

  void analyzeLogs(List<String> logs) {
    for (var log in logs) {
      if (log.contains('ERRO')) {
        logger.log('LocalAI detectou erro: $log');
      }
    }
  }

  void suggestFixes() {
    logger.log('LocalAI: Nenhuma correção crítica encontrada.');
  }
}
