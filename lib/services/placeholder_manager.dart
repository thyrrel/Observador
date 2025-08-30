import 'dart:io';

class PlaceholderManager {
  final String placeholderDir = 'placeholders';

  Future<void> init() async {
    final dir = Directory(placeholderDir);
    if (!await dir.exists()) await dir.create(recursive: true);
  }

  Future<void> addPlaceholder(String name, String content) async {
    final file = File('$placeholderDir/$name.txt');
    await file.writeAsString(content);
  }

  Future<String?> readPlaceholder(String name) async {
    final file = File('$placeholderDir/$name.txt');
    return await file.exists() ? await file.readAsString() : null;
  }
}
