import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/dashboard_service.dart';

void main() {
  test('Dashboard coleta e limpa dados', () {
    final dashboard = DashboardService();
    dashboard.collectMetrics();
    expect(dashboard.metrics.isNotEmpty, true);

    dashboard.clearMetrics();
    expect(dashboard.metrics.isEmpty, true);
  });
}
