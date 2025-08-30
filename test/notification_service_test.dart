import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/notification_service.dart';

void main() {
  test('NotificationService envia notificações', () async {
    final notif = NotificationService();
    bool sent = await notif.sendNotification('Test', 'Mensagem teste');
    expect(sent, true);
  });
}
