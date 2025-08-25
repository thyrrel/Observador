import 'package:flutter/foundation.dart';
import '../services/network_service.dart';

class NetworkProvider extends ChangeNotifier {
  final NetworkService _networkService = NetworkService();
  Map<String, dynamic> _networkData = {};
  bool _loading = false;

  Map<String, dynamic> get networkData => _networkData;
  bool get loading => _loading;

  Future<void> loadNetworkData() async {
    _loading = true;
    notifyListeners();

    _networkData = await _networkService.getNetworkStatus();

    _loading = false;
    notifyListeners();
  }
}
