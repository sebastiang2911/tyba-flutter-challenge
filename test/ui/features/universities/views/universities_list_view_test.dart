import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tyba_technical_test/app/router.dart';

import 'package:tyba_technical_test/ui/features/universities/views/university_detail_view.dart';

import '../../../../support/fake_university_repository.dart';
import '../../../../support/pump_app.dart';

Future<({FakeUniversityRepository repository, GoRouter router})> _pump(
  WidgetTester tester, {
  int count = 45,
  bool fail = false,
}) async {
  final repository = FakeUniversityRepository(buildUniversities(count))
    ..fail = fail;
  final router = await pumpApp(tester, universities: repository);
  return (repository: repository, router: router);
}

void main() {
  testWidgets('shows a progress indicator while loading', (tester) async {
    final repository = FakeUniversityRepository(buildUniversities(45));
    final gate = Completer<void>();
    repository.gate = gate.future;
    await pumpApp(tester, universities: repository, location: AppRoutes.list);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('shows name and country once loaded', (tester) async {
    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text('University 0'), findsOneWidget);
    expect(find.text('Country'), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows the empty message', (tester) async {
    await _pump(tester, count: 0);
    await tester.pumpAndSettle();

    expect(find.text('No universities found'), findsOneWidget);
  });

  testWidgets('shows error and retry reloads', (tester) async {
    final (:repository, router: _) = await _pump(tester, fail: true);
    await tester.pumpAndSettle();

    expect(find.text('Could not load universities'), findsOneWidget);

    repository.fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('University 0'), findsOneWidget);
  });

  testWidgets('list layout reveals the next page when scrolling to the end', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();
    expect(find.text('University 39', skipOffstage: false), findsNothing);

    await tester.dragUntilVisible(
      find.text('University 39'),
      find.byType(ListView),
      const Offset(0, -300),
    );

    expect(find.text('University 39'), findsOneWidget);
  });

  testWidgets('toggle switches to grid and back', (tester) async {
    await _pump(tester);
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byTooltip('Show grid'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);

    await tester.tap(find.byTooltip('Show list'));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('grid layout reveals the next page when scrolling', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show grid'));
    await tester.pumpAndSettle();

    await tester.fling(find.byType(GridView), const Offset(0, -5000), 5000);
    await tester.pumpAndSettle();
    await tester.fling(find.byType(GridView), const Offset(0, -5000), 5000);
    await tester.pumpAndSettle();

    expect(find.text('University 30', skipOffstage: false), findsOneWidget);
  });

  testWidgets('tapping a university opens its detail in list and grid', (
    tester,
  ) async {
    final (repository: _, :router) = await _pump(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('University 2'));
    await tester.pumpAndSettle();
    expect(find.byType(UniversityDetailView), findsOneWidget);

    router.go(AppRoutes.list);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show grid'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('University 3'));
    await tester.pumpAndSettle();
    expect(find.byType(UniversityDetailView), findsOneWidget);
  });

  testWidgets('back from the detail returns to the list keeping the grid', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show grid'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('University 3'));
    await tester.pumpAndSettle();
    expect(find.byType(UniversityDetailView), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(UniversityDetailView), findsNothing);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('University 3'), findsOneWidget);
  });
}
