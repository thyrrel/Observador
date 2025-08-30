import 'package:flutter/material.dart';
import 'initializer.dart';
import 'services/theme_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initializer = Initializer();
  await initializer.initializeApp();

  // Inicializa tema salvo ou padrão
  final themeService = initializer.themeService;

  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  const MyApp({required this.themeService, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeService.currentThemeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'Observador',
          theme: theme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
