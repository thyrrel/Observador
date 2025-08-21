import 'package:flutter/material.dart';
import 'package:observador/pages/home_page.dart';
import 'package:observador/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = await ThemeService.load();
  runApp(ObservadorApp(initialTheme: theme));
}

class ObservadorApp extends StatefulWidget {
  final ThemeMode initialTheme;
  const ObservadorApp({super.key, required this.initialTheme});

  @override
  State<ObservadorApp> createState() => _ObservadorAppState();
}

class _ObservadorAppState extends State<ObservadorApp> {
  late ThemeMode _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.initialTheme;
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    setState(() => _theme = mode);
    await ThemeService.save(mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador v2',
      themeMode: _theme,
      theme: ThemeService.light(),
      darkTheme: _theme == ThemeMode.values[2]
          ? ThemeService.matrix()
          : ThemeService.dark(),
      home: const HomePage(),
    );
  }
}
