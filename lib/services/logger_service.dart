import 'dart:io';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  final List<String> _logs = [];

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final entry = '[$timestamp] $message';
    _logs.add(entry);
    print(entry);
  }

  List<String> getLogs() => List.unmodifiable(_logs);

  void saveLogs(String filePath) {
    final file = File(filePath);
    file.writeAsStringSync(_logs.join('\n'), mode: FileMode.write);
  }
}
