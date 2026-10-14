import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/router.dart';
import 'package:tyba_technical_test/domain/models/university.dart';
import 'package:tyba_technical_test/ui/features/universities/views/university_detail_view.dart';

import '../../../../support/fake_university_profile_repository.dart';
import '../../../../support/fake_university_repository.dart';
import '../../../../support/pump_app.dart';

Future<FakeUniversityProfileRepository> _pump(
  WidgetTester tester, {
  int id = 1,
  bool fail = false,
  List<University>? universities,
  FakeUniversityProfileRepository? profiles,
}) async {
  // Tall viewport so the lazy ListView builds the whole detail.
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  profiles ??= FakeUniversityProfileRepository();
  final router = await pumpApp(
    tester,
    universities: FakeUniversityRepository(universities ?? buildUniversities(5))
      ..fail = fail,
    profiles: profiles,
  );
  await tester.pumpAndSettle();
  router.go(AppRoutes.detailFor(id));
  await tester.pumpAndSettle();
  return profiles;
}

Future<void> _submit(WidgetTester tester, String value) async {
  await tester.enterText(find.byType(TextField), value);
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the university information', (tester) async {
    await _pump(tester);

    expect(find.text('University 1'), findsWidgets);
    expect(find.text('Country'), findsNothing);
    expect(find.textContaining('Country: Country'), findsOneWidget);
    expect(find.text('No image assigned'), findsOneWidget);
  });

  testWidgets('shows the optional university fields', (tester) async {
    await _pump(
      tester,
      universities: [
        const University(
          id: 0,
          name: 'Full University',
          country: 'Colombia',
          alphaTwoCode: 'CO',
          stateProvince: 'Antioquia',
          domains: ['full.edu', 'full.org'],
          webPages: ['https://full.edu', 'https://full.org'],
        ),
      ],
      id: 0,
    );

    expect(find.textContaining('State/Province: Antioquia'), findsOneWidget);
    expect(find.textContaining('Domains: full.edu, full.org'), findsOneWidget);
    expect(
      find.textContaining('https://full.edu\nhttps://full.org'),
      findsOneWidget,
    );
  });

  testWidgets('hides the optional fields when absent', (tester) async {
    await _pump(tester);

    expect(find.textContaining('State/Province'), findsNothing);
    expect(find.textContaining('Domains'), findsNothing);
    expect(find.textContaining('Web pages'), findsNothing);
  });

  testWidgets('shows an error when the university is missing', (tester) async {
    await _pump(tester, id: 99);

    expect(find.text('University not found'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('retry reloads the university after a failure', (tester) async {
    final universities = FakeUniversityRepository(buildUniversities(5))
      ..fail = true;
    final router = await pumpApp(tester, universities: universities);
    await tester.pumpAndSettle();
    router.go(AppRoutes.detailFor(1));
    await tester.pumpAndSettle();
    expect(find.text('Could not load universities'), findsOneWidget);

    universities.fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsNothing);
    expect(find.textContaining('Country: Country'), findsOneWidget);
  });

  testWidgets('shows the picked image', (tester) async {
    await _pump(tester);

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(find.text('No image assigned'), findsNothing);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('shows a fallback icon when the image cannot be loaded', (
    tester,
  ) async {
    final profiles = FakeUniversityProfileRepository()
      ..nextPickedPath = '/does/not/exist.png';
    await _pump(tester, profiles: profiles);

    await tester.tap(find.text('Gallery'));
    await tester.pump(); // builds the Image, which starts the file read
    // Let the real file IO fail before the frame that builds the fallback.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.broken_image), findsOneWidget);
  });

  testWidgets('shows the picker failure', (tester) async {
    final profiles = FakeUniversityProfileRepository()..failPick = true;
    await _pump(tester, profiles: profiles);

    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(find.text('Could not pick the image'), findsOneWidget);
  });

  testWidgets('saves a valid student count', (tester) async {
    final profiles = await _pump(tester);

    await _submit(tester, '1500');

    expect(profiles.getProfile(1).studentCount, 1500);
    expect(find.textContaining('Must be'), findsNothing);
  });

  for (final (input, message) in [
    ('', 'Enter the number of students'),
    ('12.5', 'Must be a whole number'),
    ('0', 'Must be between 1 and 10000000'),
  ]) {
    testWidgets('shows "$message" for "$input"', (tester) async {
      final profiles = await _pump(tester);

      await _submit(tester, input);

      expect(find.text(message), findsOneWidget);
      expect(profiles.getProfile(1).studentCount, isNull);
    });
  }

  testWidgets('shows the saved count when reopening', (tester) async {
    final profiles = FakeUniversityProfileRepository()
      ..saveStudentCount(1, 321);
    await _pump(tester, profiles: profiles);

    expect(find.text('321'), findsOneWidget);
  });

  testWidgets('back button goes to the list when opened directly', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(5)),
      location: AppRoutes.detailFor(1),
    );
    await tester.pumpAndSettle();
    expect(find.byType(UniversityDetailView), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(UniversityDetailView), findsNothing);
    expect(find.text('University 0'), findsOneWidget);
  });

  testWidgets('system back goes to the list when opened directly', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(5)),
      location: AppRoutes.detailFor(1),
    );
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(UniversityDetailView), findsNothing);
    expect(find.text('University 0'), findsOneWidget);
  });
}
