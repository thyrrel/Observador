import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppState extends ChangeNotifier {
  bool _darkMode = false;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  bool get darkMode => _darkMode;

  Future<void> loadTheme() async {
    final value = await _storage.read(key: 'darkMode');
    _darkMode = value == 'true';
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _darkMode = value;
    await _storage.write(key: 'darkMode', value: value.toString());
    notifyListeners();
  }
}
