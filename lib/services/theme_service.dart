enum AppTheme { light, dark, oled, matrix }

class ThemeManager {
  AppTheme currentTheme = AppTheme.light;

  void setTheme(AppTheme theme) {
    currentTheme = theme;
  }

  bool isDark() => currentTheme == AppTheme.dark;
  bool isOled() => currentTheme == AppTheme.oled;
  bool isMatrix() => currentTheme == AppTheme.matrix;
}
