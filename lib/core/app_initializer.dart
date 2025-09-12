// /lib/core/app_initializer.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🚀 AppInitializer - Inicialização do app     ┃
// ┃ 🔧 Carrega dados e injeta dependências       ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../services/storage_service.dart';
import '../models/device_model.dart';

class AppInitializer extends StatelessWidget {
  final Widget child;

  const AppInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DeviceModel>>(
      future: StorageService().loadDevices(),

      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final devices = snapshot.data ?? [];

        final provider = NetworkProvider();
        for (final device in devices) {
          provider.addDevice(device);
        }

        return ChangeNotifierProvider.value(
          value: provider,
          child: child,
        );
      },
    );
  }
}
