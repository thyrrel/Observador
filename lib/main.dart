import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/network_provider.dart';
import 'screens/network_screen.dart';

void main() {
  runApp(const ObservadorApp());
}

class ObservadorApp extends StatelessWidget {
  const ObservadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkProvider()..loadNetworkData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Observador',
        theme: ThemeData.dark(useMaterial3: true),
        home: const NetworkScreen(),
      ),
    );
  }
}
