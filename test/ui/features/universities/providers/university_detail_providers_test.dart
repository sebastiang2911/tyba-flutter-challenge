import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/providers.dart';
import 'package:tyba_technical_test/domain/failures/failure.dart';
import 'package:tyba_technical_test/domain/models/university_profile.dart';
import 'package:tyba_technical_test/domain/validators/student_count_validator.dart';
import 'package:tyba_technical_test/ui/features/universities/providers/providers.dart';

import '../../../../support/fake_university_profile_repository.dart';
import '../../../../support/fake_university_repository.dart';

void main() {
  late FakeUniversityRepository universities;
  late FakeUniversityProfileRepository profiles;
  late ProviderContainer container;

  setUp(() {
    universities = FakeUniversityRepository(buildUniversities(5));
    profiles = FakeUniversityProfileRepository();
    container = ProviderContainer(
      overrides: [
        universityRepositoryProvider.overrideWithValue(universities),
        universityProfileRepositoryProvider.overrideWithValue(profiles),
      ],
    );
    addTearDown(container.dispose);
  });

  /// Auto-dispose: keeps the profile provider alive for the whole test.
  UniversityProfileNotifier profileNotifier([int id = 2]) {
    container.listen(universityProfileProvider(id), (_, _) {});
    return container.read(universityProfileProvider(id).notifier);
  }

  UniversityProfileState stateOf([int id = 2]) =>
      container.read(universityProfileProvider(id));

  test('starts loading, then exposes the university', () async {
    container.listen(universityProvider(2), (_, _) {});
    expect(container.read(universityProvider(2)).isLoading, isTrue);

    final university = await container.read(universityProvider(2).future);

    expect(university.id, 2);
  });

  test('exposes an error when the university cannot be loaded', () async {
    container.listen(universityProvider(99), (_, _) {});

    await expectLater(
      container.read(universityProvider(99).future),
      throwsA(isA<Failure>()),
    );

    final error = container.read(universityProvider(99)).error as Failure;
    expect(error.message, 'University not found');
  });

  test('exposes the stored profile', () {
    profiles.saveStudentCount(2, 90);

    profileNotifier();

    expect(stateOf().profile.studentCount, 90);
    expect(stateOf().imageError, isNull);
    expect(stateOf().studentCountError, isNull);
  });

  test('assigns the picked image', () async {
    final notifier = profileNotifier();

    await notifier.pickImage(PhotoSource.gallery);

    expect(stateOf().profile.imagePath, '/tmp/picked.png');
    expect(stateOf().imageError, isNull);
  });

  test('keeps the profile and reports a picker failure', () async {
    final notifier = profileNotifier();
    profiles.saveStudentCount(2, 10);
    await notifier.pickImage(PhotoSource.gallery);
    profiles.failPick = true;

    await notifier.pickImage(PhotoSource.camera);

    expect(stateOf().profile.imagePath, '/tmp/picked.png');
    expect(stateOf().imageError, 'Could not pick the image');
  });

  for (final fails in [false, true]) {
    test('ignores a pick that resolves after the provider is disposed '
        '(${fails ? 'failure' : 'success'})', () async {
      final subscription = container.listen(
        universityProfileProvider(2),
        (_, _) {},
      );
      final notifier = container.read(universityProfileProvider(2).notifier);
      profiles.pickGate = Completer<void>();
      profiles.failPick = fails;

      final pending = notifier.pickImage(PhotoSource.gallery);
      subscription.close();
      await Future<void>.delayed(Duration.zero);
      profiles.pickGate!.complete();

      await expectLater(pending, completes);
    });
  }

  test('saves a valid student count', () {
    final notifier = profileNotifier();

    notifier.submitStudentCount(' 1200 ');

    expect(stateOf().profile.studentCount, 1200);
    expect(stateOf().studentCountError, isNull);
    expect(profiles.getProfile(2).studentCount, 1200);
  });

  test('does not save an invalid student count', () {
    final notifier = profileNotifier();
    notifier.submitStudentCount('50');

    notifier.submitStudentCount('abc');

    expect(stateOf().studentCountError, StudentCountError.notInteger);
    expect(stateOf().profile.studentCount, 50);
    expect(profiles.getProfile(2).studentCount, 50);
  });

  test('profiles are independent per university', () {
    profileNotifier(1).submitStudentCount('10');
    profileNotifier(2);

    expect(stateOf(1).profile.studentCount, 10);
    expect(stateOf(2).profile.studentCount, isNull);
  });
}
