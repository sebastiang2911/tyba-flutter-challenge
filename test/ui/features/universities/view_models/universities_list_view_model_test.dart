import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/ui/features/universities/view_models/universities_list_view_model.dart';

import '../../../../support/fake_university_repository.dart';

void main() {
  late FakeUniversityRepository repository;
  late UniversitiesListViewModel viewModel;

  void setUpWith(int count) {
    repository = FakeUniversityRepository(buildUniversities(count));
    viewModel = UniversitiesListViewModel(repository);
  }

  test('starts in loading with list layout', () {
    setUpWith(1);

    expect(viewModel.state.status, UniversitiesListStatus.loading);
    expect(viewModel.state.layout, UniversitiesLayout.list);
  });

  test('load exposes the first 20 universities in source order', () async {
    setUpWith(45);

    await viewModel.load();

    expect(viewModel.state.status, UniversitiesListStatus.data);
    expect(
      viewModel.state.visible.map((u) => u.id),
      List.generate(20, (i) => i),
    );
    expect(viewModel.state.hasMore, isTrue);
  });

  test('load without universities yields empty', () async {
    setUpWith(0);

    await viewModel.load();

    expect(viewModel.state.status, UniversitiesListStatus.empty);
    expect(viewModel.state.hasMore, isFalse);
  });

  test('load failure yields error with message, retry recovers', () async {
    setUpWith(3);
    repository.fail = true;

    await viewModel.load();

    expect(viewModel.state.status, UniversitiesListStatus.error);
    expect(viewModel.state.errorMessage, 'Could not load universities');

    repository.fail = false;
    final loading = viewModel.load();
    expect(viewModel.state.status, UniversitiesListStatus.loading);
    await loading;

    expect(viewModel.state.status, UniversitiesListStatus.data);
    expect(viewModel.state.errorMessage, isNull);
  });

  test('loadMore appends pages in order until exhausted', () async {
    setUpWith(45);
    await viewModel.load();

    viewModel.loadMore();
    expect(viewModel.state.visible.length, 40);
    expect(viewModel.state.hasMore, isTrue);

    viewModel.loadMore();
    expect(
      viewModel.state.visible.map((u) => u.id),
      List.generate(45, (i) => i),
    );
    expect(viewModel.state.hasMore, isFalse);

    viewModel.loadMore();
    expect(viewModel.state.visible.length, 45);
  });

  test('exactly one page has no more items', () async {
    setUpWith(20);

    await viewModel.load();

    expect(viewModel.state.hasMore, isFalse);
  });

  test('loadMore is a no-op outside the data state', () async {
    setUpWith(45);

    viewModel.loadMore();

    expect(viewModel.state.visible, isEmpty);
  });

  test('visible list cannot be mutated', () async {
    setUpWith(5);
    await viewModel.load();

    expect(() => viewModel.state.visible.clear(), throwsUnsupportedError);
  });

  test('toggleLayout switches both ways and keeps items', () async {
    setUpWith(30);
    await viewModel.load();

    viewModel.toggleLayout();
    expect(viewModel.state.layout, UniversitiesLayout.grid);
    expect(viewModel.state.visible.length, 20);

    viewModel.toggleLayout();
    expect(viewModel.state.layout, UniversitiesLayout.list);
  });

  test('notifies listeners on changes', () async {
    setUpWith(5);
    var notifications = 0;
    viewModel.addListener(() => notifications++);

    await viewModel.load();
    viewModel.toggleLayout();

    expect(notifications, greaterThanOrEqualTo(3));
  });
}
