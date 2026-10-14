import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_university_repository.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('boots to the universities list', (tester) async {
    await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(3)),
    );
    await tester.pumpAndSettle();

    expect(find.text('University 0'), findsOneWidget);
  });

  testWidgets('follows the system dark appearance', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(3)),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.text('University 0'));
    expect(Theme.of(context).brightness, Brightness.dark);
  });

  testWidgets('follows the system light appearance', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(3)),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.text('University 0'));
    expect(Theme.of(context).brightness, Brightness.light);
  });
}
