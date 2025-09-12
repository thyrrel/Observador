import 'logger_service.dart';

class DashboardAI {
  final LoggerService logger = LoggerService();

  void showStatus() {
    logger.log('DashboardIA: Mostrando status atual da IA');
    final logs = logger.getLogs();
    logs.forEach((l) => print(l));
  }
}
