import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/router_provider.dart';
import '../models/router_model.dart';

class RoutersScreen extends StatelessWidget {
  const RoutersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routerProvider = Provider.of<RouterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Observador - Roteadores"),
        centerTitle: true,
      ),
      body: routerProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => routerProvider.loadRouters(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: routerProvider.routers.length,
                itemBuilder: (context, index) {
                  final router = routerProvider.routers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.router),
                      title: Text(router.name),
                      subtitle: Text("IP: ${router.ip} • Modelo: ${router.model}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editRouterName(context, routerProvider, router);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _editRouterName(BuildContext context, RouterProvider provider, RouterModel router) {
    TextEditingController controller = TextEditingController(text: router.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome do roteador'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              provider.updateRouterName(router.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
