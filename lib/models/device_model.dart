// 📦 lib/widgets/device_tile.dart
// 🔧 Widget de item de dispositivo com ações visuais
// ✍️ Forjado byThyrrel

import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../providers/network_provider.dart';
import 'package:provider/provider.dart';

class DeviceTile extends StatelessWidget {
  final DeviceModel device;

  const DeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(device.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Remover dispositivo'),
            content: Text('Deseja remover "${device.name}" da lista?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remover')),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<NetworkProvider>(context, listen: false).removeDevice(device.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dispositivo "${device.name}" removido')),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: const Icon(Icons.devices, color: Colors.blue),

          title: Text(device.name),
          subtitle: Text('${device.ip} • ${device.mac}'),

          // 📊 Indicador de tráfego (mockado para exemplo)
          isThreeLine: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          dense: false,

          trailing: Consumer<NetworkProvider>(
            builder: (_, provider, __) {
              final blocked = provider.isBlocked(device.id);
              return IconButton(
                icon: Icon(
                  blocked ? Icons.lock : Icons.lock_open,
                  color: blocked ? Colors.red : Colors.green,
                ),
                tooltip: blocked ? 'Desbloquear dispositivo' : 'Bloquear dispositivo',
                onPressed: () {
                  provider.toggleBlockDevice(device.id);
                },
              );
            },
          ),

          // 👇 Adiciona barra de tráfego abaixo do IP/MAC
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${device.ip} • ${device.mac}'),
              const SizedBox(height: 4),
              Consumer<NetworkProvider>(
                builder: (_, provider, __) {
                  final traffic = provider.getTraffic(device.id);
                  final total = traffic.totalRx + traffic.totalTx;
                  final percent = total > 0 ? traffic.totalRx / total : 0.5;

                  return LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                    minHeight: 6,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
