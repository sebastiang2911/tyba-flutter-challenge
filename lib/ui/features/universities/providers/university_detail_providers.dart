import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers.dart';
import '../../../../domain/failures/failure.dart';
import '../../../../domain/models/university.dart';
import '../../../../domain/models/university_profile.dart';
import '../../../../domain/validators/student_count_validator.dart';

part 'university_detail_providers.g.dart';

/// The university with the given sequential [id].
@Riverpod(retry: noRetry)
Future<University> university(Ref ref, int id) =>
    ref.watch(universityRepositoryProvider).getUniversityById(id);

/// What the user assigned to a university plus the last action errors.
@immutable
class UniversityProfileState {
  const UniversityProfileState({
    this.profile = const UniversityProfile(),
    this.studentCountError,
    this.imageError,
  });

  final UniversityProfile profile;
  final StudentCountError? studentCountError;
  final String? imageError;
}

@riverpod
class UniversityProfileNotifier extends _$UniversityProfileNotifier {
  @override
  UniversityProfileState build(int universityId) => UniversityProfileState(
    profile: ref
        .watch(universityProfileRepositoryProvider)
        .getProfile(universityId),
  );

  Future<void> pickImage(PhotoSource source) async {
    try {
      final profile = await ref
          .read(universityProfileRepositoryProvider)
          .pickImage(universityId, source);
      state = UniversityProfileState(profile: profile);
    } on Failure catch (failure) {
      state = UniversityProfileState(
        profile: state.profile,
        imageError: failure.message,
      );
    }
  }

  /// Saves [input] when valid and returns true; otherwise exposes the
  /// validation error and returns false.
  bool submitStudentCount(String input) {
    final error = StudentCountValidator.validate(input);
    if (error != null) {
      state = UniversityProfileState(
        profile: state.profile,
        studentCountError: error,
      );
      return false;
    }
    final profile = ref
        .read(universityProfileRepositoryProvider)
        .saveStudentCount(universityId, int.parse(input.trim()));
    state = UniversityProfileState(profile: profile);
    return true;
  }
}
