import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppTheme { Light, Dark, OLED, Matrix }

class AppState extends ChangeNotifier {
  AppTheme _theme = AppTheme.Light;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AppTheme get theme => _theme;

  ThemeData get themeData {
    switch (_theme) {
      case AppTheme.Dark:
        return ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey[800],
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
        );
      case AppTheme.OLED:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
        );
      case AppTheme.Matrix:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.greenAccent),
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.greenAccent)),
        );
      case AppTheme.Light:
      default:
        return ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlue[200]),
        );
    }
  }

  Future<void> loadTheme() async {
    final value = await _storage.read(key: 'theme');
    if (value != null) {
      _theme = AppTheme.values.firstWhere((e) => e.toString() == value, orElse: () => AppTheme.Light);
    }
    notifyListeners();
  }

  Future<void> setTheme(AppTheme newTheme) async {
    _theme = newTheme;
    await _storage.write(key: 'theme', value: newTheme.toString());
    notifyListeners();
  }
}
