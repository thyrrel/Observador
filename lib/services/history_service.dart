import '../models/device_model.dart';

class HistoryService {
  final List<String> _history = [];

  void logDecision(DeviceModel device, String action) {
    final entry = '${DateTime.now()}: $action -> ${device.ip}';
    _history.add(entry);
  }

  List<String> getHistory() => List.from(_history);
}
