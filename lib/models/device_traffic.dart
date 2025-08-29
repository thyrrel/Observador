class DeviceTraffic {
  final String day;
  final int rxBytes; // Download
  final int txBytes; // Upload

  DeviceTraffic({
    required this.day,
    required this.rxBytes,
    required this.txBytes,
  });
}
