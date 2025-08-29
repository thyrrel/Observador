import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100],
    cardColor: Colors.white,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black87,
    cardColor: Colors.grey[900],
  );

  static ThemeData oled = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.black,
    canvasColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.greenAccent),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.greenAccent)),
  );

  static ThemeData matrix = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.black.withOpacity(0.3),
    canvasColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.greenAccent),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.greenAccent, fontFamily: 'Courier'),
    ),
  );
}
