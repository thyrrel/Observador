import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/network_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ObservadorApp());
}

class ObservadorApp extends StatelessWidget {
  const ObservadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: MaterialApp(
        title: 'Observador',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
