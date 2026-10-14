import '../models/university_profile.dart';

abstract interface class UniversityProfileRepository {
  /// Returns what was assigned to the university so far; empty if nothing.
  UniversityProfile getProfile(int universityId);

  /// Stores an already validated student count.
  UniversityProfile saveStudentCount(int universityId, int count);

  /// Lets the user pick an image and assigns it to the university.
  ///
  /// Keeps the current image when the user cancels. Throws a `Failure` when
  /// the picker fails.
  Future<UniversityProfile> pickImage(int universityId, PhotoSource source);
}
