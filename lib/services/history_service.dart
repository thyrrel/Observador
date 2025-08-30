import 'storage_service.dart';

class HistoryService {
  final StorageService storageService;
  final String _historyKey = 'network_history';

  HistoryService({required this.storageService});

  Future<List<String>> getHistory() async {
    final data = await storageService.read(_historyKey);
    return data?.split(',') ?? [];
  }

  Future<void> addEntry(String entry) async {
    final history = await getHistory();
    history.add(entry);
    await storageService.save(_historyKey, history.join(','));
  }

  Future<void> clearHistory() async {
    await storageService.delete(_historyKey);
  }
}
