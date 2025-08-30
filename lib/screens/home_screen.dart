import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Observador"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => themeService.setTheme(value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: "light", child: Text("Claro")),
              const PopupMenuItem(value: "dark", child: Text("Escuro")),
              const PopupMenuItem(value: "oled", child: Text("OLED")),
              const PopupMenuItem(value: "matrix", child: Text("Matrix")),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Monitorando sua rede...",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
