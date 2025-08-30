import 'storage_service.dart';

class LoggerService {
  final StorageService storageService;
  final String _logKey = 'app_logs';

  LoggerService({required this.storageService});

  Future<void> log(String message) async {
    final logs = await getLogs();
    logs.add('${DateTime.now()}: $message');
    await storageService.save(_logKey, logs.join('\n'));
  }

  Future<List<String>> getLogs() async {
    final data = await storageService.read(_logKey);
    return data?.split('\n') ?? [];
  }

  Future<void> clearLogs() async {
    await storageService.delete(_logKey);
  }
}
