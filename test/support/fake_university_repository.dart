import 'package:tyba_technical_test/domain/failures/failure.dart';
import 'package:tyba_technical_test/domain/models/university.dart';
import 'package:tyba_technical_test/domain/repositories/university_repository.dart';

List<University> buildUniversities(int count) => [
  for (var i = 0; i < count; i++)
    University(
      id: i,
      name: 'University $i',
      country: 'Country',
      alphaTwoCode: 'CC',
      domains: const [],
      webPages: const [],
    ),
];

class FakeUniversityRepository implements UniversityRepository {
  FakeUniversityRepository(this.universities);

  /// Fails every call until set to `false`.
  bool fail = false;
  List<University> universities;

  /// When set, loading waits for it (simulates a slow fetch).
  Future<void>? gate;

  @override
  Future<List<University>> getUniversities() async {
    await gate;
    if (fail) throw const Failure('Could not load universities');
    return universities;
  }

  @override
  Future<University> getUniversityById(int id) async {
    final all = await getUniversities();
    return all.firstWhere(
      (u) => u.id == id,
      orElse: () => throw const Failure('University not found'),
    );
  }
}
