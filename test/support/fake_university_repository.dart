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

  @override
  Future<List<University>> getUniversities() async {
    if (fail) throw const Failure('Could not load universities');
    return universities;
  }
}
