class RouterDevice {
  final String mac;
  final String name;
  final int rxBytes;
  final int txBytes;
  final bool blocked;

  RouterDevice({
    required this.mac,
    required this.name,
    required this.rxBytes,
    required this.txBytes,
    required this.blocked,
  });
}
