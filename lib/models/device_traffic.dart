class DeviceTraffic {
  final String deviceName;
  final int rxBytes;
  final int txBytes;

  DeviceTraffic({
    required this.deviceName,
    required this.rxBytes,
    required this.txBytes,
  });
}
