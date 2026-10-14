import 'package:flutter/material.dart';

/// Deep indigo used as the theme seed.
const universityIndigo = Color(0xFF283593);

/// Amber accent ("graduation gold") used as the secondary color.
const universityAmber = Color(0xFFF2A93B);

/// Tyba dark gray, taken from the logo mark.
const tybaDarkGray = Color(0xFF1C262B);

ThemeData buildLightTheme() => _build(Brightness.light);

ThemeData buildDarkTheme() => _build(Brightness.dark);

ThemeData _build(Brightness brightness) {
  final seeded = ColorScheme.fromSeed(
    seedColor: universityIndigo,
    brightness: brightness,
  );
  final branded = seeded.copyWith(
    secondary: universityAmber,
    onSecondary: tybaDarkGray,
  );
  final scheme = brightness == Brightness.dark
      ? branded.copyWith(surface: tybaDarkGray)
      : branded.copyWith(onSurface: tybaDarkGray);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: universityIndigo,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
