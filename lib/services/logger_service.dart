// lib/services/logger_service.dart
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  final StreamController<String> _controller = StreamController.broadcast();
  Stream<String> get logStream => _controller.stream;

  late File _logFile;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _logFile = File("${dir.path}/logs.txt");
    if (!await _logFile.exists()) {
      await _logFile.create();
    }
  }

  Future<void> log(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final line = "[$timestamp] $message";
    await _logFile.writeAsString("$line\n", mode: FileMode.append);
    _controller.add(line);
  }

  Future<List<String>> getAllLogs() async {
    if (!await _logFile.exists()) return [];
    return await _logFile.readAsLines();
  }
}
