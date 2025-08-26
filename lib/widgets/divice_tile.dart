import 'package:flutter/material.dart';
import '../services/network_service.dart';
import 'package:provider/provider.dart';

class DeviceTile extends StatelessWidget {
  final NetworkDevice device;
  const DeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final networkService = Provider.of<NetworkService>(context);

    return ListTile(
      title: Text(device.name),
      subtitle: Text('${device.ip} | ${device.mac}'),
      trailing: IconButton(
        icon: Icon(
          device.blocked ? Icons.lock : Icons.lock_open,
          color: device.blocked ? Colors.red : Colors.green,
        ),
        onPressed: () {
          networkService.toggleBlock(device);
        },
      ),
    );
  }
}
