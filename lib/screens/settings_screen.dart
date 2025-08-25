import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Tema Escuro'),
            subtitle: const Text('Ativa ou desativa o modo escuro'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
                // Aqui depois você pode chamar um provider ou service para salvar a preferência
              });
            },
          ),
          ListTile(
            title: const Text('Sobre'),
            subtitle: const Text('Informações sobre o Observador'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Observador',
                applicationVersion: '1.0.0',
                children: const [
                  Text('Aplicativo de monitoramento e controle de redes e dispositivos.'),
                ],
              );
            },
          ),
          ListTile(
            title: const Text('Backup/Restaurar Configurações'),
            subtitle: const Text('Em breve integração com nuvem e exportação de dados'),
            onTap: () {
              // Placeholder para futuras integrações
            },
          ),
        ],
      ),
    );
  }
}
