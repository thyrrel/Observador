import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Observador')),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.networkData.length,
              itemBuilder: (context, index) {
                final key = provider.networkData.keys.elementAt(index);
                return ListTile(
                  title: Text(key),
                  subtitle: Text(provider.networkData[key].toString()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.loadNetworkData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
