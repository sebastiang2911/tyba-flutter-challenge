import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/providers.dart';
import 'package:tyba_technical_test/domain/failures/failure.dart';
import 'package:tyba_technical_test/ui/features/universities/providers/providers.dart';

import '../../../../support/fake_university_repository.dart';

void main() {
  late FakeUniversityRepository repository;
  late ProviderContainer container;
  var listening = false;

  void setUpWith(int count) {
    repository = FakeUniversityRepository(buildUniversities(count));
    listening = false;
    container = ProviderContainer(
      overrides: [universityRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  }

  VisibleUniversities visible() {
    if (!listening) {
      // Auto-dispose: keep it alive for the rest of the test.
      container.listen(visibleUniversitiesProvider, (_, _) {});
      listening = true;
    }
    return container.read(visibleUniversitiesProvider);
  }

  void loadMore() => container.read(visibleCountProvider.notifier).loadMore();

  test('starts loading with list layout', () async {
    setUpWith(1);

    expect(container.read(universitiesProvider).isLoading, isTrue);
    expect(container.read(universitiesLayoutProvider), UniversitiesLayout.list);
    expect(visible().items, isEmpty);
    await container.read(universitiesProvider.future);
  });

  test('loads the universities in source order', () async {
    setUpWith(45);

    final all = await container.read(universitiesProvider.future);

    expect(all.map((u) => u.id), List.generate(45, (i) => i));
  });

  test('exposes the first 20 universities and more to come', () async {
    setUpWith(45);
    await container.read(universitiesProvider.future);

    expect(visible().items.map((u) => u.id), List.generate(20, (i) => i));
    expect(visible().hasMore, isTrue);
  });

  test('yields an empty list without universities', () async {
    setUpWith(0);

    final all = await container.read(universitiesProvider.future);

    expect(all, isEmpty);
    expect(visible().items, isEmpty);
    expect(visible().hasMore, isFalse);
  });

  test('failure yields an error with its message, retry recovers', () async {
    setUpWith(3);
    repository.fail = true;

    await expectLater(
      container.read(universitiesProvider.future),
      throwsA(isA<Failure>()),
    );
    final error = container.read(universitiesProvider).error as Failure;
    expect(error.message, 'Could not load universities');

    repository.fail = false;
    container.invalidate(universitiesProvider);
    final all = await container.read(universitiesProvider.future);

    expect(all.length, 3);
    expect(container.read(universitiesProvider).hasError, isFalse);
  });

  test('loadMore appends pages in order until exhausted', () async {
    setUpWith(45);
    await container.read(universitiesProvider.future);

    loadMore();
    expect(visible().items.length, 40);
    expect(visible().hasMore, isTrue);

    loadMore();
    expect(visible().items.map((u) => u.id), List.generate(45, (i) => i));
    expect(visible().hasMore, isFalse);
  });

  test('loadMore is a no-op when nothing remains', () async {
    setUpWith(45);
    await container.read(universitiesProvider.future);
    loadMore();
    loadMore();

    loadMore();

    expect(container.read(visibleCountProvider), 60);
    expect(visible().items.length, 45);
  });

  test('exactly one page has no more items', () async {
    setUpWith(20);
    await container.read(universitiesProvider.future);

    loadMore();

    expect(visible().items.length, 20);
    expect(visible().hasMore, isFalse);
    expect(container.read(visibleCountProvider), 20);
  });

  test('loadMore is a no-op before the data is loaded', () async {
    setUpWith(45);

    loadMore();

    expect(container.read(visibleCountProvider), universitiesPageSize);
    await container.read(universitiesProvider.future);
  });

  test('visible list cannot be mutated', () async {
    setUpWith(5);
    await container.read(universitiesProvider.future);

    expect(() => visible().items.clear(), throwsUnsupportedError);
  });

  test('toggle switches layout both ways and keeps items', () async {
    setUpWith(30);
    await container.read(universitiesProvider.future);

    container.read(universitiesLayoutProvider.notifier).toggle();
    expect(container.read(universitiesLayoutProvider), UniversitiesLayout.grid);
    expect(visible().items.length, 20);

    container.read(universitiesLayoutProvider.notifier).toggle();
    expect(container.read(universitiesLayoutProvider), UniversitiesLayout.list);
  });
}
