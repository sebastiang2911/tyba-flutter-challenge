import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/ui/features/splash/views/splash_view.dart';
import 'package:tyba_technical_test/ui/features/universities/views/universities_list_view.dart';

import '../../../../support/fake_university_repository.dart';
import '../../../../support/pump_app.dart';

void main() {
  testWidgets('opens on the splash with the wordmark', (tester) async {
    final gate = Completer<void>();
    final repository = FakeUniversityRepository(buildUniversities(5))
      ..gate = gate.future;
    await pumpApp(tester, universities: repository);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SplashView), findsOneWidget);
    expect(find.bySemanticsLabel('Tyba'), findsOneWidget);
    expect(find.byType(UniversitiesListView), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('waits for the fetch, then opens the list', (tester) async {
    final gate = Completer<void>();
    final repository = FakeUniversityRepository(buildUniversities(5))
      ..gate = gate.future;
    await pumpApp(tester, universities: repository);

    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SplashView), findsOneWidget);

    gate.complete();
    await tester.pumpAndSettle();

    expect(find.byType(SplashView), findsNothing);
    expect(find.text('University 0'), findsOneWidget);
  });

  testWidgets('waits for the minimum duration even when the fetch is fast', (
    tester,
  ) async {
    await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(5)),
      splashMinDuration: const Duration(milliseconds: 800),
    );

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.byType(SplashView), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(SplashView), findsNothing);
    expect(find.byType(UniversitiesListView), findsOneWidget);
  });

  testWidgets('opens the list with its error and retry when the fetch fails', (
    tester,
  ) async {
    final repository = FakeUniversityRepository(buildUniversities(5))
      ..fail = true;
    await pumpApp(tester, universities: repository);
    await tester.pumpAndSettle();

    expect(find.byType(SplashView), findsNothing);
    expect(find.text('Could not load universities'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('back from the list does not return to the splash', (
    tester,
  ) async {
    final router = await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(5)),
    );
    await tester.pumpAndSettle();

    expect(router.canPop(), isFalse);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(SplashView), findsNothing);
    expect(find.byType(UniversitiesListView), findsOneWidget);
  });
}
