import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.loadTheme();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
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
      theme: appState.themeData,
      home: AdminScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
