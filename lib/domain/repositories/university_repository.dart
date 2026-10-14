import '../models/university.dart';

abstract interface class UniversityRepository {
  /// Returns all universities in source order, each with a sequential `id`.
  ///
  /// Throws a `Failure` when the data cannot be loaded.
  Future<List<University>> getUniversities();

  /// Returns the university with the given sequential [id].
  ///
  /// Throws a `Failure` when it does not exist or the data cannot be loaded.
  Future<University> getUniversityById(int id);
}
