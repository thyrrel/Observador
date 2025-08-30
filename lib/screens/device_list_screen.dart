import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/network_service.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).themeData;
    final networkService = Provider.of<NetworkService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos da Rede'),
        backgroundColor: theme.primaryColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: networkService.devices.isEmpty
          ? Center(
              child: Text(
                'Nenhum dispositivo encontrado',
                style: theme.textTheme.bodyText1,
              ),
            )
          : ListView.builder(
              itemCount: networkService.devices.length,
              itemBuilder: (context, index) {
                final device = networkService.devices[index];
                return DeviceTile(
                  device: device,
                  theme: theme,
                );
              },
            ),
    );
  }
}
