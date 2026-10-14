import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/data/repositories/university_profile_repository_impl.dart';
import 'package:tyba_technical_test/data/services/image_picker_service.dart';
import 'package:tyba_technical_test/domain/failures/failure.dart';
import 'package:tyba_technical_test/domain/models/university_profile.dart';

class _FakePicker implements ImagePickerService {
  String? path = '/tmp/a.png';
  bool fail = false;
  PhotoSource? lastSource;

  @override
  Future<String?> pick(PhotoSource source) async {
    lastSource = source;
    if (fail) throw StateError('boom');
    return path;
  }
}

void main() {
  late _FakePicker picker;
  late InMemoryUniversityProfileRepository repository;

  setUp(() {
    picker = _FakePicker();
    repository = InMemoryUniversityProfileRepository(picker);
  });

  test('returns an empty profile by default', () {
    final profile = repository.getProfile(1);

    expect(profile.imagePath, isNull);
    expect(profile.studentCount, isNull);
  });

  test('keeps count and image per university id', () async {
    repository.saveStudentCount(1, 500);
    await repository.pickImage(1, PhotoSource.camera);

    final profile = repository.getProfile(1);
    expect(profile.studentCount, 500);
    expect(profile.imagePath, '/tmp/a.png');
    expect(picker.lastSource, PhotoSource.camera);
    expect(repository.getProfile(2).studentCount, isNull);
  });

  test('keeps the current image when the picker is cancelled', () async {
    await repository.pickImage(1, PhotoSource.gallery);
    picker.path = null;

    final profile = await repository.pickImage(1, PhotoSource.gallery);

    expect(profile.imagePath, '/tmp/a.png');
  });

  test('maps picker errors to a Failure', () {
    picker.fail = true;

    expect(
      repository.pickImage(1, PhotoSource.gallery),
      throwsA(const Failure('Could not pick the image')),
    );
  });
}
