// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ ⚡ NovaActionService - Executor de decisões da IA    ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../../../models/device_model.dart';
import '../../../services/router_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef VoiceCallback = void Function(String msg);

class NovaActionService {
  final RouterService routerService;
  final VoiceCallback voiceCallback;
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  NovaActionService({
    required this.routerService,
    required this.voiceCallback,
    required this.notificationsPlugin,
  });

  // Prioriza dispositivo via QoS
  void prioritize(DeviceModel device, {int priority = 200}) {
    routerService.prioritizeDevice(device.mac, priority: priority);
    _notify('Dispositivo ${device.name} priorizado com QoS $priority');
  }

  // Bloqueia dispositivo (se suportado)
  void block(DeviceModel device) {
    routerService.blockDevice(device.mac);
    _notify('Dispositivo ${device.name} bloqueado pela IA');
  }

  // Envia notificação + voz
  void _notify(String msg) async {
    voiceCallback(msg);
    var androidDetails = AndroidNotificationDetails(
      'ia_actions',
      'IA Actions',
      channelDescription: 'Ações executadas pela IA',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, 'NOVA', msg, platformDetails);
  }
}
