import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tyba_technical_test/app/router.dart';
import 'package:tyba_technical_test/ui/core/skeleton.dart';

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

/// Settles frames without `pumpAndSettle`: the load-more spinner may be built
/// in the grid's cache extent and animates forever.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  testWidgets('shows skeleton placeholders while loading', (tester) async {
    final repository = FakeUniversityRepository(buildUniversities(45));
    final gate = Completer<void>();
    repository.gate = gate.future;
    await pumpApp(tester, universities: repository, location: AppRoutes.list);
    // Let the route transition bring the list onstage.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ListSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('shows name and country once loaded', (tester) async {
    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text('University 0'), findsOneWidget);
    expect(find.text('Country'), findsWidgets);
    expect(find.byType(ListSkeleton), findsNothing);
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
    await _settle(tester);
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byTooltip('Show grid'));
    await _settle(tester);
    expect(find.byType(SliverGrid), findsOneWidget);
    expect(find.byType(ListView), findsNothing);

    await tester.tap(find.byTooltip('Show list'));
    await _settle(tester);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('grid layout reveals the next page when scrolling', (
    tester,
  ) async {
    await _pump(tester);
    await _settle(tester);
    await tester.tap(find.byTooltip('Show grid'));
    await _settle(tester);

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -5000),
      5000,
    );
    await _settle(tester);
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -5000),
      5000,
    );
    await _settle(tester);

    expect(find.text('University 30', skipOffstage: false), findsOneWidget);
  });

  testWidgets('tapping a university opens its detail in list and grid', (
    tester,
  ) async {
    final (repository: _, :router) = await _pump(tester);
    await _settle(tester);

    await tester.tap(find.text('University 2'));
    await _settle(tester);
    expect(find.byType(UniversityDetailView), findsOneWidget);

    router.go(AppRoutes.list);
    await _settle(tester);
    await tester.tap(find.byTooltip('Show grid'));
    await _settle(tester);
    await tester.tap(find.text('University 3'));
    await _settle(tester);
    expect(find.byType(UniversityDetailView), findsOneWidget);
  });

  testWidgets('back from the detail returns to the list keeping the grid', (
    tester,
  ) async {
    await _pump(tester);
    await _settle(tester);
    await tester.tap(find.byTooltip('Show grid'));
    await _settle(tester);

    await tester.tap(find.text('University 3'));
    await _settle(tester);
    expect(find.byType(UniversityDetailView), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await _settle(tester);

    expect(find.byType(UniversityDetailView), findsNothing);
    expect(find.byType(SliverGrid), findsOneWidget);
    expect(find.text('University 3'), findsOneWidget);
  });

  testWidgets('shows the load-more indicator while items remain', (
    tester,
  ) async {
    // Tall viewport so the whole first page and the footer are built.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _pump(tester);
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 600));
    }

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('hides the load-more indicator once everything is shown', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();

    for (var i = 0; i < 4; i++) {
      await tester.drag(find.byType(ListView), const Offset(0, -100000));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    expect(find.text('University 44'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('does not show the load-more indicator when all fit one page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _pump(tester, count: 10);
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('keeps pagination working after switching layout twice', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show grid'));
    await _settle(tester);
    await tester.tap(find.byTooltip('Show list'));
    await _settle(tester);

    await tester.dragUntilVisible(
      find.text('University 39'),
      find.byType(ListView),
      const Offset(0, -300),
    );

    expect(find.text('University 39'), findsOneWidget);
  });

  Finder heroWithTag(String tag) =>
      find.byWidgetPredicate((w) => w is Hero && w.tag == tag);

  Future<void> expectHeroesFlyToDetail(WidgetTester tester) async {
    await tester.tap(find.text('University 2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(heroWithTag('university-2-title'), findsWidgets);
    expect(heroWithTag('university-2-avatar'), findsWidgets);
    await _settle(tester);
    expect(find.byType(UniversityDetailView), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(UniversityDetailView),
        matching: find.text('U'),
      ),
      findsOneWidget,
    );
  }

  testWidgets('the initial and name fly to the detail from the list', (
    tester,
  ) async {
    await _pump(tester);
    await _settle(tester);

    await expectHeroesFlyToDetail(tester);
  });

  testWidgets('the initial and name fly to the detail from the grid', (
    tester,
  ) async {
    await _pump(tester);
    await _settle(tester);
    await tester.tap(find.byTooltip('Show grid'));
    await _settle(tester);

    await expectHeroesFlyToDetail(tester);
  });

  testWidgets('opens the detail without animation when disabled', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _pump(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('University 2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.byType(UniversityDetailView), findsOneWidget);
  });
}
