import 'package:workmanager/workmanager.dart';
import 'package:observador/services/traffic_collector_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final collector = TrafficCollectorService();
    collector.startMonitoring((data) {
      // TODO: processar uso de tráfego
    });
    return true;
  });
}
