// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 NovaSnapshot - Estado observado por N.O.V.A.      ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import '../models/device_model.dart';

class NovaSnapshot {
  final DeviceModel device;
  final double mbps;
  final String usageType;
  final List<double> history;

  NovaSnapshot({
    required this.device,
    required this.mbps,
    required this.usageType,
    required this.history,
  });
}
