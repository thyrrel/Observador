import 'package:flutter_test/flutter_test.dart';
import 'package:observador/providers/theme_provider.dart';

void main() {
  test('Alterna tema', () {
    final theme = ThemeProvider();
    expect(theme.isDark, false);

    theme.toggleTheme();
    expect(theme.isDark, true);

    theme.toggleTheme();
    expect(theme.isDark, false);
  });
}
