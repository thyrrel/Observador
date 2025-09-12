// /lib/utils/classify_device_type.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 classifyDeviceType - Inferência de tipo de dispositivo ┃
// ┃ 🔍 Baseado em nome, fabricante e tráfego                ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

String classifyDeviceType(String name, String manufacturer, int rx, int tx) {
  final total = rx + tx;
  final lowerName = name.toLowerCase();
  final lowerMan = manufacturer.toLowerCase();

  if (lowerName.contains('iphone') || lowerMan.contains('apple')) return 'Celular';
  if (lowerName.contains('tv') || lowerMan.contains('samsung') || lowerMan.contains('lg')) return 'TV';
  if (lowerName.contains('ps') || lowerName.contains('xbox') || lowerName.contains('switch')) return 'Console';
  if (lowerName.contains('desktop') || lowerName.contains('pc') || lowerMan.contains('dell')) return 'PC';
  if (lowerMan.contains('raspberry') || lowerMan.contains('synology')) return 'Servidor';
  if (lowerMan.contains('tp-link') || lowerMan.contains('tuya') || total < 50000) return 'IoT';
  if (lowerName.contains('guest') || lowerMan.isEmpty) return 'Desconhecido';

  return 'Celular';
}
