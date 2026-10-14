import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/ui/core/skeleton.dart';

void main() {
  testWidgets('ListSkeleton renders the requested number of rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ListSkeleton(itemCount: 3))),
    );

    // Two blocks per row.
    expect(find.byType(Skeleton), findsNWidgets(6));
  });

  testWidgets('Skeleton pulses its opacity', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Skeleton(width: 50))),
    );
    double opacity() => tester
        .widget<FadeTransition>(
          find
              .descendant(
                of: find.byType(Skeleton),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;

    final start = opacity();
    await tester.pump(const Duration(milliseconds: 450));

    expect(opacity(), isNot(start));
  });

  testWidgets('Skeleton is static when animations are disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(home: Scaffold(body: Skeleton(width: 50))),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Skeleton), findsOneWidget);
  });
}
