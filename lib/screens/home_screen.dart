import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../services/network_service.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';
import '../services/wifi_credentials_service.dart';
import '../services/router_credentials_service.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NetworkService _networkService;
  late RouterService _routerService;
  late IAService _iaService;
  late WifiCredentialsService _wifiService;
  late RouterCredentialsService _routerCredService;

  List<DeviceModel> devices = [];
  Map<String, double> usage = {}; // IP -> Mbps
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _networkService = NetworkService();
    _wifiService = WifiCredentialsService();
    _routerCredService = RouterCredentialsService();
    _iaService = IAService(voiceCallback: _voiceAlert);
    _initRouter();
    _scanDevices();
  }

  Future<void> _initRouter() async {
    _routerService = RouterService(
      routerIP: '192.168.0.1', // Substituir pelo gateway real
      username: 'admin',
      password: 'admin
