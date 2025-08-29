import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'ia_service.dart';

class IAScheduler {
  final IAService iaService;
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  Timer? _timer;

  IAScheduler({required this.iaService, required this.notificationsPlugin});

  /// Inicializa o agendamento contínuo
  void start({Duration interval = const Duration(seconds: 30)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) async {
      await _runAnalysis();
    });
  }

  /// Para o agendamento
  void stop() {
    _timer?.cancel();
  }

  /// Executa a análise e envia notificações se necessário
  Future<void> _runAnalysis() async {
    await iaService.analyzeAllRouters();
    _sendNotifications();
  }

  /// Exemplo: envia notificações locais para alertas
  void _sendNotifications() {
    // Aqui você pode percorrer alertas ou mensagens geradas pela IA
    // Exemplo simplificado:
    iaService.devices.where((d) => d.type.contains('Desconhecido')).forEach((device) {
      _showNotification(
        title: 'Dispositivo suspeito',
        body: 'Dispositivo ${device.name} detectado na rede.',
      );
    });
  }

  Future<void> _showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'ia_channel',
      'IA Alerts',
      channelDescription: 'Notificações da IA de monitoramento',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }
}
