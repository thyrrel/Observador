import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';

import 'providers/network_provider.dart';
import 'providers/dns_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'services/network_service.dart';
import 'services/dns_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização de serviços
  await NotificationService().init();
  await AuthService().init();

  runApp(const ObservadorApp());
}

class ObservadorApp extends StatelessWidget {
  const ObservadorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => DNSProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Observador',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueAccent,
          scaffoldBackgroundColor: Colors.black,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blueAccent,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
