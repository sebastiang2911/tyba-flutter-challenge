import 'package:flutter/foundation.dart';

import '../../../../domain/failures/failure.dart';
import '../../../../domain/models/university.dart';
import '../../../../domain/models/university_profile.dart';
import '../../../../domain/repositories/university_profile_repository.dart';
import '../../../../domain/repositories/university_repository.dart';
import '../../../../domain/validators/student_count_validator.dart';

enum UniversityDetailStatus { loading, error, data }

/// Immutable snapshot of what the detail screen shows.
@immutable
class UniversityDetailState {
  const UniversityDetailState({
    this.status = UniversityDetailStatus.loading,
    this.university,
    this.profile = const UniversityProfile(),
    this.studentCountError,
    this.errorMessage,
    this.imageError,
  });

  final UniversityDetailStatus status;
  final University? university;
  final UniversityProfile profile;
  final StudentCountError? studentCountError;
  final String? errorMessage;
  final String? imageError;
}

class UniversityDetailViewModel extends ChangeNotifier {
  UniversityDetailViewModel(
    this._universities,
    this._profiles, {
    required this.universityId,
  });

  final int universityId;
  final UniversityRepository _universities;
  final UniversityProfileRepository _profiles;

  UniversityDetailState _state = const UniversityDetailState();

  UniversityDetailState get state => _state;

  Future<void> load() async {
    _emit(const UniversityDetailState());
    try {
      final university = await _universities.getUniversityById(universityId);
      _emit(
        UniversityDetailState(
          status: UniversityDetailStatus.data,
          university: university,
          profile: _profiles.getProfile(universityId),
        ),
      );
    } on Failure catch (failure) {
      _emit(
        UniversityDetailState(
          status: UniversityDetailStatus.error,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> pickImage(PhotoSource source) async {
    try {
      final profile = await _profiles.pickImage(universityId, source);
      _emit(_data(profile: profile));
    } on Failure catch (failure) {
      _emit(_data(imageError: failure.message));
    }
  }

  /// Saves [input] when valid; otherwise exposes the validation error.
  void submitStudentCount(String input) {
    final error = StudentCountValidator.validate(input);
    if (error != null) {
      _emit(_data(studentCountError: error));
      return;
    }
    final profile = _profiles.saveStudentCount(
      universityId,
      int.parse(input.trim()),
    );
    _emit(_data(profile: profile));
  }

  /// Keeps the loaded data; errors reset unless provided.
  UniversityDetailState _data({
    UniversityProfile? profile,
    StudentCountError? studentCountError,
    String? imageError,
  }) {
    return UniversityDetailState(
      status: UniversityDetailStatus.data,
      university: _state.university,
      profile: profile ?? _state.profile,
      studentCountError: studentCountError,
      imageError: imageError,
    );
  }

  void _emit(UniversityDetailState next) {
    _state = next;
    notifyListeners();
  }
}
