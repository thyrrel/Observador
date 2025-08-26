import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administração'),
      ),
      body: const Center(
        child: Text('Aqui você pode gerenciar credenciais e configurações do sistema.'),
      ),
    );
  }
}
