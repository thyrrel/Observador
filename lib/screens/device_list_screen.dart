// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 device_list_screen.dart - Tela que exibe dispositivos da rede ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../services/network_service.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final ThemeData theme = appState.themeData;

    final NetworkService networkService = Provider.of<NetworkService>(context);
    final List<Device> devices = networkService.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos da Rede'),
        backgroundColor: theme.primaryColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: devices.isEmpty
          ? Center(
              child: Text(
                'Nenhum dispositivo encontrado',
                style: theme.textTheme.bodyText1,
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                final Device device = devices[index];

                return DeviceTile(
                  device: device,
                  theme: theme,
                );
              },
            ),
    );
  }
}

// Sugestões
// - 🔤 Renomear `theme` para `themeData` para maior clareza
// - 🧩 Extrair o widget `ListView.builder` para uma função separada
// - 🛡️ Adicionar fallback visual para erro de rede ou carregamento
// - 📦 Verificar se `Device` possui tipagem explícita no modelo
// - 🧼 Usar `Consumer` ao invés de `Provider.of` para melhor performance

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
