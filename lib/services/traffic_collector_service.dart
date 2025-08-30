// lib/services/traffic_collector_service.dart
import 'dart:async';

typedef TrafficCallback = void Function(Map<String, double> usageMbps);

class TrafficCollectorService {
  Timer? _timer;

  void startMonitoring(TrafficCallback callback, {int intervalSeconds = 5}) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (_) {
      // Aqui normalmente você coletaria tráfego real
      callback({'192.168.0.2': 5.2, '192.168.0.3': 12.3});
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
  }
}
