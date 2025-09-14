// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 network_screen.dart - Tela que exibe o status da rede no app    ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/network_provider.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkProvider networkProvider = Provider.of<NetworkProvider>(context);

    final bool isLoading = networkProvider.loading;
    final Map<String, dynamic> networkData = networkProvider.networkData;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Observador - Status da Rede"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await networkProvider.loadNetworkData();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (networkData.isEmpty)
                    const Center(child: Text("Nenhum dado carregado")),
                  ...networkData.entries.map((MapEntry<String, dynamic> entry) {
                    final String key = entry.key;
                    final dynamic value = entry.value;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(key),
                        subtitle: value is List
                            ? Text(value.join(", "))
                            : Text(value.toString()),
                        leading: const Icon(Icons.wifi),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await networkProvider.loadNetworkData();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// Sugestões
// - 🧩 Extrair o widget de Card/ListTile para uma função separada (`_buildNetworkCard`)
// - 🛡️ Adicionar tratamento para falhas em `loadNetworkData()` com `try/catch`
// - 🔤 Tipar explicitamente os valores do mapa se possível (`Map<String, List<String>` por exemplo)
// - 📦 Usar `Consumer` ao invés de `Provider.of` para rebuilds mais eficientes
// - 🧼 Adicionar animação ou feedback visual ao `RefreshIndicator`

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
