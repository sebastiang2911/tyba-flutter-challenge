import '../models/university.dart';

abstract interface class UniversityRepository {
  /// Returns all universities in source order, each with a sequential `id`.
  ///
  /// Throws a `Failure` when the data cannot be loaded.
  Future<List<University>> getUniversities();
}
