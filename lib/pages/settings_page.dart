import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _themeMode = ThemeMode.system;
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await _themeService.load();
    setState(() {
      _themeMode = mode ?? ThemeMode.system;
    });
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    await _themeService.save(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Tema do Aplicativo'),
            subtitle: Text(_themeMode.name),
            trailing: DropdownButton<ThemeMode>(
              value: _themeMode,
              onChanged: (mode) async {
                if (mode != null) {
                  setState(() {
                    _themeMode = mode;
                  });
                  await _saveTheme(mode);
                }
              },
              items: ThemeMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.name),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Simulação de ThemeService para evitar erros
class ThemeService {
  Future<ThemeMode?> load() async {
    // Aqui poderia carregar do SharedPreferences ou armazenamento seguro
    return ThemeMode.system;
  }

  Future<void> save(ThemeMode mode) async {
    // Aqui poderia salvar no SharedPreferences ou armazenamento seguro
    debugPrint('Tema salvo: ${mode.name}');
  }
}
