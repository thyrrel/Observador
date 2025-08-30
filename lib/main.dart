import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/theme_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Guarda-costas WIFI',
      debugShowCheckedModeBanner: false,
      theme: themeService.theme,
      home: const HomeScreen(),
    );
  }
}
