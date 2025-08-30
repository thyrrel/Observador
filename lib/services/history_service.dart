// lib/services/history_service.dart
import '../models/device_model.dart';

class HistoryService {
  final List<Map<String, dynamic>> _history = [];

  void addRecord(DeviceModel device, String action) {
    _history.add({
      'timestamp': DateTime.now().toIso8601String(),
      'device': device,
      'action': action,
    });
  }

  List<Map<String, dynamic>> get history => _history;

  void clearHistory() => _history.clear();
}
