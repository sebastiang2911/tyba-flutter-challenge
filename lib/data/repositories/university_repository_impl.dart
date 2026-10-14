import '../../domain/failures/failure.dart';
import '../../domain/models/university.dart';
import '../../domain/repositories/university_repository.dart';
import '../services/universities_api_service.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  UniversityRepositoryImpl(this._service);

  final UniversitiesApiService _service;

  @override
  Future<List<University>> getUniversities() async {
    try {
      final models = await _service.fetchUniversities();
      // The id is the source index, assigned before any sort or filter.
      return [
        for (final (index, model) in models.indexed) model.toDomain(index),
      ];
    } catch (_) {
      throw const Failure('Could not load universities');
    }
  }

  @override
  Future<University> getUniversityById(int id) async {
    final universities = await getUniversities();
    for (final university in universities) {
      if (university.id == id) return university;
    }
    throw const Failure('University not found');
  }
}
