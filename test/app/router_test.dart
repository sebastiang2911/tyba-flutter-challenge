import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tyba_technical_test/app/router.dart';

Future<GoRouter> _pump(WidgetTester tester) async {
  final router = buildRouter();
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  return router;
}

void main() {
  testWidgets('starts on the list route', (tester) async {
    await _pump(tester);

    expect(find.text('Universities list'), findsOneWidget);
  });

  testWidgets('resolves the detail route with its id', (tester) async {
    final router = await _pump(tester);

    router.go('/university/3');
    await tester.pumpAndSettle();

    expect(find.text('University detail #3'), findsOneWidget);
  });

  testWidgets('detailFor builds a path that resolves to that id', (
    tester,
  ) async {
    final router = await _pump(tester);

    router.go(AppRoutes.detailFor(7));
    await tester.pumpAndSettle();

    expect(find.text('University detail #7'), findsOneWidget);
  });
}
