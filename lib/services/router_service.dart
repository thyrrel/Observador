/// Passo 7 – Priorizar banda para um dispositivo
Future<bool> prioritizeDevice(String mac, {int priority = 100}) async {
  switch (routerType) {
    case 'TP-Link':
      return await _prioritizeTPLink(mac, priority);
    case 'ASUS':
      return await _prioritizeASUS(mac, priority);
    case 'D-Link':
      return await _prioritizeDLink(mac, priority);
    default:
      return false;
  }
}

Future<bool> _prioritizeTPLink(String mac, int priority) async {
  // Exemplo: enviar requisição real para API TP-Link
  print('TP-Link: priorizando $mac com prioridade $priority');
  return true;
}

Future<bool> _prioritizeASUS(String mac, int priority) async {
  print('ASUS: priorizando $mac com prioridade $priority');
  return true;
}

Future<bool> _prioritizeDLink(String mac, int priority) async {
  print('D-Link: priorizando $mac com prioridade $priority');
  return true;
}
