import 'package:flutter/material.dart';
import 'package:observador/models/network_device.dart';
import 'package:observador/providers/network_provider.dart';

class DeviceTile extends StatelessWidget {
  final NetworkDevice device;
  final NetworkProvider provider;

  const DeviceTile({
    super.key,
    required this.device,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.ip),
      trailing: IconButton(
        icon: const Icon(Icons.block),
        onPressed: () => provider.toggleBlockDevice(device.id),
      ),
    );
  }
}
