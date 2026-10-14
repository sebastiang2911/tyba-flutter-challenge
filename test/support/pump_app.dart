import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tyba_technical_test/app/app.dart';
import 'package:tyba_technical_test/app/providers.dart';
import 'package:tyba_technical_test/app/router.dart';
import 'package:tyba_technical_test/domain/repositories/university_profile_repository.dart';
import 'package:tyba_technical_test/domain/repositories/university_repository.dart';
import 'package:tyba_technical_test/ui/features/splash/providers/splash_providers.dart';

import 'fake_university_profile_repository.dart';

/// Pumps [App] with fake repositories and returns its router.
///
/// Starts at the splash, whose minimum duration is [splashMinDuration].
/// Opens [location] instead when given (e.g. a deep link).
Future<GoRouter> pumpApp(
  WidgetTester tester, {
  required UniversityRepository universities,
  UniversityProfileRepository? profiles,
  String? location,
  Duration splashMinDuration = const Duration(milliseconds: 1),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        universityRepositoryProvider.overrideWithValue(universities),
        splashMinDurationProvider.overrideWithValue(splashMinDuration),
        universityProfileRepositoryProvider.overrideWithValue(
          profiles ?? FakeUniversityProfileRepository(),
        ),
      ],
      child: const App(),
    ),
  );
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  final router = container.read(appRouterProvider);
  if (location != null) {
    // Leave the splash before its timer fires so it cannot override [location].
    await tester.pump();
    router.go(location);
    await tester.pump();
  }
  return router;
}
