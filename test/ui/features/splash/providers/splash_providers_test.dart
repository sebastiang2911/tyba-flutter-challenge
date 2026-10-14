import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/providers.dart';
import 'package:tyba_technical_test/domain/models/university.dart';
import 'package:tyba_technical_test/domain/repositories/university_repository.dart';
import 'package:tyba_technical_test/ui/features/splash/providers/splash_providers.dart';

import '../../../../support/fake_university_repository.dart';

class _DelayedRepository implements UniversityRepository {
  _DelayedRepository(this.completer);

  final Completer<List<University>> completer;

  @override
  Future<List<University>> getUniversities() => completer.future;

  @override
  Future<University> getUniversityById(int id) async =>
      (await completer.future).firstWhere((u) => u.id == id);
}

const _minDuration = Duration(milliseconds: 800);

ProviderContainer _container(UniversityRepository repository) {
  final container = ProviderContainer(
    overrides: [
      universityRepositoryProvider.overrideWithValue(repository),
      splashMinDurationProvider.overrideWithValue(_minDuration),
    ],
  );
  addTearDown(container.dispose);
  // Auto-dispose: keep it alive while the test runs.
  container.listen(splashReadyProvider, (_, _) {});
  return container;
}

void main() {
  test('fast fetch waits for the minimum duration', () {
    fakeAsync((async) {
      final container = _container(
        FakeUniversityRepository(buildUniversities(3)),
      );

      async.elapse(_minDuration - const Duration(milliseconds: 1));
      expect(container.read(splashReadyProvider).isLoading, isTrue);

      async.elapse(const Duration(milliseconds: 1));
      expect(container.read(splashReadyProvider).hasValue, isTrue);
    });
  });

  test('slow fetch waits for the fetch to finish', () {
    fakeAsync((async) {
      final completer = Completer<List<University>>();
      final container = _container(_DelayedRepository(completer));

      async.elapse(_minDuration * 2);
      expect(container.read(splashReadyProvider).isLoading, isTrue);

      completer.complete(buildUniversities(3));
      async.flushMicrotasks();
      expect(container.read(splashReadyProvider).hasValue, isTrue);
    });
  });

  test('failed fetch still completes', () {
    fakeAsync((async) {
      final container = _container(
        FakeUniversityRepository(const [])..fail = true,
      );

      async.elapse(_minDuration);
      expect(container.read(splashReadyProvider).hasValue, isTrue);
    });
  });
}
