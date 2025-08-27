import 'package:flutter/material.dart';
import '../services/network_service.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';

class DeviceTile extends StatelessWidget {
  final NetworkDevice device;

  const DeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NetworkProvider>(context, listen: false);

    return ListTile(
      leading: Icon(device.blocked ? Icons.lock : Icons.devices),
      title: Text(device.name),
      subtitle: Text('${device.ip}\n${device.mac}'),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(device.blocked ? Icons.lock_open : Icons.lock),
        onPressed: () {
          provider.toggleBlockDevice(device);
        },
      ),
    );
  }
}
