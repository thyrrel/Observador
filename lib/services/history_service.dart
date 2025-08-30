// lib/services/history_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  late File _historyFile;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _historyFile = File("${dir.path}/history.json");
    if (!await _historyFile.exists()) {
      await _historyFile.create();
      await _historyFile.writeAsString(jsonEncode([]));
    }
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final content = await _historyFile.readAsString();
    return List<Map<String, dynamic>>.from(jsonDecode(content));
  }

  Future<void> addEntry(Map<String, dynamic> entry) async {
    final history = await getHistory();
    history.add(entry);
    await _historyFile.writeAsString(jsonEncode(history));
  }

  Future<void> clearHistory() async {
    await _historyFile.writeAsString(jsonEncode([]));
  }
}
