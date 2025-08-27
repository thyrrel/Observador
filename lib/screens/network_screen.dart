import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Observador - Status da Rede"),
        centerTitle: true,
      ),
      body: networkProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => networkProvider.loadNetworkData(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (networkProvider.networkData.isEmpty)
                    const Center(child: Text("Nenhum dado carregado")),
                  ...networkProvider.networkData.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(entry.key),
                        subtitle: entry.value is List
                            ? Text((entry.value as List).join(", "))
                            : Text(entry.value.toString()),
                        leading: const Icon(Icons.wifi),
                      ),
                    );
                  }),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => networkProvider.loadNetworkData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
