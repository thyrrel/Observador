import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/admin_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: ObservadorApp(),
    ),
  );
}

class ObservadorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      title: 'Observador - Smart Home',
      theme: appState.darkMode
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.blueGrey[800],
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: Colors.cyan[300],
              ),
            )
          : ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: Colors.lightBlue[200],
              ),
            ),
      home: AdminScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
