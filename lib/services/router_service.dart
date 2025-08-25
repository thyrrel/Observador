import 'dart:io';

class RouterService {
  final String routerIP;
  final String token; // Pode ser senha admin ou token da API

  RouterService({required this.routerIP, required this.token});

  Future<String> detectRouterType() async {
    // Detecta gateway padrão
    ProcessResult result = await Process.run('ip', ['route']);
    String gateway = '';
    if (result.stdout != null) {
      final lines = result.stdout.toString().split('\n');
      for (var line in lines) {
        if (line.contains('default via')) {
          gateway = line.split(' ')[2];
          break;
        }
      }
    }

    // Tentativa de fingerprint via HTTP
    try {
      final response = await HttpClient()
          .getUrl(Uri.parse('http://$gateway'))
          .then((req) => req.close());
      if (response.statusCode == 200) {
        final headers = response.headers.value('Server') ?? '';
        if (headers.contains('TP-LINK')) return 'TP-Link';
        if (headers.contains('ASUS')) return 'ASUS';
        if (headers.contains('D-Link')) return 'D-Link';
      }
    } catch (_) {}
    return 'Desconhecido';
  }
}
