// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});

class AppTheme {
  static const Color _darkNavy = Color(0xFF0D1117);
  static const Color _darkSurface = Color(0xFF161B22);
  static const Color _darkCardSurface = Color(0xFF21262D);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
      // ignore: deprecated_member_use
      background: _darkNavy,
      surface: _darkNavy, // Fondo principal
      // --- ¡CAMBIO AQUÍ! ---
      // Asignamos nuestro color de tarjeta al color que usas
      surfaceContainerHighest: _darkCardSurface,
      onSurfaceVariant: Colors.grey[400], // Para el texto de subtítulos
      // --- FIN CAMBIO ---
    ),

    scaffoldBackgroundColor: _darkNavy,
    cardColor: _darkCardSurface, // Color para las tarjetas (Home, etc)

    cardTheme: CardThemeData(
      color: _darkCardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _darkNavy,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkSurface,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _darkCardSurface,
      side: BorderSide(color: Colors.grey[700]!),
      labelStyle: const TextStyle(color: Colors.white),
    ),

    useMaterial3: true,
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  );
}
