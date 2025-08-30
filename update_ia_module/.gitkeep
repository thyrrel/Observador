import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/theme_service.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart'; // gerado pelo FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const UpdateIAModuleApp(),
    ),
  );
}

class UpdateIAModuleApp extends StatelessWidget {
  const UpdateIAModuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Observador IA Module',
      debugShowCheckedModeBanner: false,
      theme: themeService.theme,
      home: const HomeScreen(),
    );
  }
}
