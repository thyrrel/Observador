import 'package:flutter/material.dart';
import 'package:observador/services/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode _current;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _current = await ThemeService.load();
    setState(() {});
  }

  Future<void> _save(ThemeMode mode) async {
    await ThemeService.save(mode);
    setState(() => _current = mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tema', style: TextStyle(fontSize: 18)),
          RadioListTile<ThemeMode>(
            title: const Text('Claro'),
            value: ThemeMode.light,
            groupValue: _current,
            onChanged: _save,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Escuro'),
            value: ThemeMode.dark,
            groupValue: _current,
            onChanged: _save,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Matrix (VIP+)'),
            value: ThemeMode.values[2], // Matrix
            groupValue: _current,
            onChanged: (v) async {
              // só permite se VIP+
              final isVipPlus = true; // substituir pela sua lógica
              if (isVipPlus) {
                _save(v!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema Matrix é VIP+')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
