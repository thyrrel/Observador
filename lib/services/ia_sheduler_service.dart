// lib/services/ia_scheduler_service.dart
import 'dart:async';

typedef ScheduledTask = void Function();

class IASchedulerService {
  final List<Timer> _timers = [];

  void scheduleTask(Duration interval, ScheduledTask task) {
    Timer timer = Timer.periodic(interval, (_) => task());
    _timers.add(timer);
  }

  void cancelAll() {
    for (var t in _timers) t.cancel();
    _timers.clear();
  }
}
