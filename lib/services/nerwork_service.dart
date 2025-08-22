import 'dart:async';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';

class NetworkService {
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void startMonitoring({Duration interval = const Duration(seconds: 10)}) {
    Timer.periodic(interval, (timer) async {
      bool status = await isConnected();
      _connectionController.add(status);
    });
  }

  /// Inicializa o background fetch para monitoramento em segundo plano
  void initBackgroundFetch() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15, // em minutos
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      (String taskId) async {
        // Executa verificação de conexão em background
        bool status = await isConnected();
        _connectionController.add(status);

        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        BackgroundFetch.finish(taskId);
      },
    );
  }

  void dispose() {
    _connectionController.close();
  }
}
