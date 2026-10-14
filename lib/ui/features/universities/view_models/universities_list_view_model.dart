import 'package:flutter/foundation.dart';

import '../../../../domain/failures/failure.dart';
import '../../../../domain/models/university.dart';
import '../../../../domain/repositories/university_repository.dart';

enum UniversitiesListStatus { loading, error, empty, data }

enum UniversitiesLayout { list, grid }

/// Immutable snapshot of what the universities screen shows.
@immutable
class UniversitiesListState {
  const UniversitiesListState({
    this.status = UniversitiesListStatus.loading,
    this.visible = const [],
    this.layout = UniversitiesLayout.list,
    this.hasMore = false,
    this.errorMessage,
  });

  final UniversitiesListStatus status;
  final List<University> visible;
  final UniversitiesLayout layout;
  final bool hasMore;
  final String? errorMessage;

  UniversitiesListState copyWith({
    UniversitiesListStatus? status,
    List<University>? visible,
    UniversitiesLayout? layout,
    bool? hasMore,
    String? errorMessage,
  }) {
    return UniversitiesListState(
      status: status ?? this.status,
      visible: visible ?? this.visible,
      layout: layout ?? this.layout,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}

class UniversitiesListViewModel extends ChangeNotifier {
  UniversitiesListViewModel(this._repository);

  static const pageSize = 20;

  final UniversityRepository _repository;

  List<University> _all = const [];
  UniversitiesListState _state = const UniversitiesListState();

  UniversitiesListState get state => _state;

  Future<void> load() async {
    _emit(
      _state.copyWith(
        status: UniversitiesListStatus.loading,
        visible: const [],
      ),
    );
    try {
      _all = await _repository.getUniversities();
    } on Failure catch (failure) {
      _emit(
        _state.copyWith(
          status: UniversitiesListStatus.error,
          errorMessage: failure.message,
        ),
      );
      return;
    }
    if (_all.isEmpty) {
      _emit(_state.copyWith(status: UniversitiesListStatus.empty));
      return;
    }
    _emit(
      _state.copyWith(
        status: UniversitiesListStatus.data,
        visible: _page(pageSize),
        hasMore: _all.length > pageSize,
      ),
    );
  }

  /// Reveals the next [pageSize] universities. No-op when nothing remains.
  void loadMore() {
    if (_state.status != UniversitiesListStatus.data || !_state.hasMore) return;
    final count = _state.visible.length + pageSize;
    _emit(_state.copyWith(visible: _page(count), hasMore: _all.length > count));
  }

  void toggleLayout() {
    _emit(
      _state.copyWith(
        layout: _state.layout == UniversitiesLayout.list
            ? UniversitiesLayout.grid
            : UniversitiesLayout.list,
      ),
    );
  }

  List<University> _page(int count) => List.unmodifiable(_all.take(count));

  void _emit(UniversitiesListState next) {
    _state = next;
    notifyListeners();
  }
}
