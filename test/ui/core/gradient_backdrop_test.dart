import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/theme.dart';
import 'package:tyba_technical_test/ui/core/gradient_backdrop.dart';

void main() {
  testWidgets('fades from indigo at the top to the surface color', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: const GradientBackdrop(child: Text('content')),
      ),
    );

    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox).first);
    final gradient =
        (box.decoration as BoxDecoration).gradient! as LinearGradient;
    expect(gradient.colors.first, universityIndigo);
    expect(gradient.colors.last, buildLightTheme().colorScheme.surface);
    expect(find.text('content'), findsOneWidget);
  });
}
