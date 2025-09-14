// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 theme_service.dart - Gerenciador de temas visuais para o aplicativo ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';

class ThemeService {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );

  static Future<void> init() async {
    // TODO: carregar tema salvo de fonte persistente (ex: SharedPreferences)
  }
}

// Sugestões
// - 🛡️ Implementar persistência com SharedPreferences ou Hive
// - 🔤 Adicionar suporte a temas personalizados (ex: Matrix, OLED)
– 📦 Criar método `getTheme(AppThemeType type)` para facilitar seleção dinâmica
– 🧩 Integrar com `ChangeNotifier` ou `ValueNotifier` para reatividade
– 🎨 Sincronizar com `PlaceholderService` para consistência visual

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
