import 'package:workmanager/workmanager.dart';
import 'package:observador/services/traffic_collector.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await TrafficCollector().collectOnce();
    return true;
  });
}
