// lib/services/theme_service.dart
import 'logger_service.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final List<String> availableThemes = ["claro", "escuro", "oled", "matrix"];
  String currentTheme = "claro";

  Future<void> init() async {
    await LoggerService().log("Themes inicializados: ${availableThemes.join(", ")}");
  }

  Future<void> setCurrentTheme(String themeName) async {
    currentTheme = themeName;
    await LoggerService().log("ThemeService: Tema atual definido para $themeName");
  }
}
