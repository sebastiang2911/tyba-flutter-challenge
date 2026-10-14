import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/theme.dart';

void main() {
  test('light theme is bright with the logo dark gray as text color', () {
    final scheme = buildLightTheme().colorScheme;

    expect(scheme.brightness, Brightness.light);
    expect(scheme.onSurface, tybaDarkGray);
  });

  test('dark theme is dark with the logo dark gray as surface', () {
    final scheme = buildDarkTheme().colorScheme;

    expect(scheme.brightness, Brightness.dark);
    expect(scheme.surface, tybaDarkGray);
  });

  test('both themes derive their primary from the indigo hue', () {
    for (final theme in [buildLightTheme(), buildDarkTheme()]) {
      final hue = HSLColor.fromColor(theme.colorScheme.primary).hue;
      final expected = HSLColor.fromColor(universityIndigo).hue;
      expect((hue - expected).abs(), lessThan(20));
    }
  });

  test('both themes use the amber accent as secondary', () {
    for (final theme in [buildLightTheme(), buildDarkTheme()]) {
      expect(theme.colorScheme.secondary, universityAmber);
    }
  });

  test('app bar uses the indigo with white content in both themes', () {
    for (final theme in [buildLightTheme(), buildDarkTheme()]) {
      expect(theme.appBarTheme.backgroundColor, universityIndigo);
      expect(theme.appBarTheme.foregroundColor, Colors.white);
    }
  });
}
