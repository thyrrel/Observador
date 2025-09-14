// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 bluetooth_service.dart - Serviço para escanear e listar dispositivos ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothService {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  Stream<List<BluetoothDevice>> get connectedDevices async* {
    final List<BluetoothDevice> devices = await _flutterBlue.connectedDevices;
    yield devices;
  }

  Stream<List<ScanResult>> scanDevices({
    Duration timeout = const Duration(seconds: 5),
  }) {
    _flutterBlue.startScan(timeout: timeout);
    return _flutterBlue.scanResults.map((List<ScanResult> results) => results);
  }

  void stopScan() {
    _flutterBlue.stopScan();
  }
}

// Sugestões
// - 🛡️ Adicionar `try/catch` em `connectedDevices` para capturar falhas de acesso
// - 🔤 Permitir configuração de filtros no `startScan` (ex: serviços específicos)
// - 📦 Expor método `isScanning` para controle externo do estado
// - 🧩 Extrair lógica de mapeamento para função privada (`_mapScanResults()`)
// - 🎨 Adicionar callback ou stream para eventos de descoberta em tempo real

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
