import 'package:flutter/material.dart';

/// Tyba red, taken from the logo mark.
const tybaRed = Color(0xFFD54028);

/// Tyba dark gray, taken from the logo mark.
const tybaDarkGray = Color(0xFF1C262B);

ThemeData buildLightTheme() => _build(Brightness.light);

ThemeData buildDarkTheme() => _build(Brightness.dark);

ThemeData _build(Brightness brightness) {
  final seeded = ColorScheme.fromSeed(
    seedColor: tybaRed,
    brightness: brightness,
  );
  final scheme = brightness == Brightness.dark
      ? seeded.copyWith(surface: tybaDarkGray)
      : seeded.copyWith(onSurface: tybaDarkGray);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
