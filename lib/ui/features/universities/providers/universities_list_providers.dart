import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../../../domain/models/university.dart';

part 'universities_list_providers.g.dart';

/// How many universities each page reveals.
const universitiesPageSize = 20;

enum UniversitiesLayout { list, grid }

/// All universities in source order. Invalidate it to retry after a failure.
@Riverpod(keepAlive: true, retry: noRetry)
Future<List<University>> universities(Ref ref) =>
    ref.watch(universityRepositoryProvider).getUniversities();

@Riverpod(keepAlive: true)
class UniversitiesLayoutNotifier extends _$UniversitiesLayoutNotifier {
  @override
  UniversitiesLayout build() => UniversitiesLayout.list;

  void toggle() {
    state = state == UniversitiesLayout.list
        ? UniversitiesLayout.grid
        : UniversitiesLayout.list;
  }
}

/// How many universities are revealed so far.
@Riverpod(keepAlive: true)
class VisibleCount extends _$VisibleCount {
  @override
  int build() => universitiesPageSize;

  /// Reveals the next page. No-op when nothing remains.
  void loadMore() {
    final total = ref.read(universitiesProvider).value?.length ?? 0;
    if (state >= total) return;
    state += universitiesPageSize;
  }
}

/// The revealed slice of the universities.
@immutable
class VisibleUniversities {
  const VisibleUniversities({required this.items, required this.hasMore});

  final List<University> items;
  final bool hasMore;
}

/// Derived from [universitiesProvider] and [visibleCountProvider].
@riverpod
VisibleUniversities visibleUniversities(Ref ref) {
  final all = ref.watch(universitiesProvider).value ?? const <University>[];
  final count = ref.watch(visibleCountProvider);
  return VisibleUniversities(
    items: List.unmodifiable(all.take(count)),
    hasMore: all.length > count,
  );
}
