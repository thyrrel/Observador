import 'package:flutter/material.dart';
import 'dart:async';
import '../services/router_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DashboardScreen extends StatefulWidget {
  final RouterService routerService;

  const DashboardScreen({super.key, required this.routerService});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> activeIPs = [];
  bool scanning = false;
  Timer? scanTimer;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _startContinuousScan();
  }

  @override
  void dispose() {
    scanTimer?.cancel();
    super.dispose();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
            'network_channel', 'Monitoramento de Rede',
            channelDescription: 'Alertas de dispositivos conectados/desconectados',
            importance: Importance.max,
            priority: Priority.high);

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }

  void _startContinuousScan() {
    scanTimer = Timer.periodic(const Duration(seconds: 10), (_) => _scanNetwork());
  }

  void _scanNetwork() async {
    final newIPs = await widget.routerService.scanNetwork('192.168.1');
    final added = newIPs.where((ip) => !activeIPs.contains(ip)).toList();
    final removed = activeIPs.where((ip) => !newIPs.contains(ip)).toList();

    if (added.isNotEmpty || removed.isNotEmpty) {
      setState(() => activeIPs = newIPs);

      for (var ip in added) {
        _showNotification('Novo Dispositivo', 'Dispositivo $ip conectado');
      }
      for (var ip in removed) {
        _showNotification('Dispositivo Removido', 'Dispositivo $ip desconectado');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanning ? null : _scanNetwork,
            child: Text(scanning ? 'Escaneando...' : 'Escanear Agora'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activeIPs.length,
              itemBuilder: (context, index) {
                final ip
