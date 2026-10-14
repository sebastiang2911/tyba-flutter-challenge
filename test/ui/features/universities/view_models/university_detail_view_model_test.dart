import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/models/university_profile.dart';
import 'package:tyba_technical_test/domain/validators/student_count_validator.dart';
import 'package:tyba_technical_test/ui/features/universities/view_models/university_detail_view_model.dart';

import '../../../../support/fake_university_profile_repository.dart';
import '../../../../support/fake_university_repository.dart';

void main() {
  late FakeUniversityRepository universities;
  late FakeUniversityProfileRepository profiles;

  UniversityDetailViewModel build([int id = 2]) =>
      UniversityDetailViewModel(universities, profiles, universityId: id);

  setUp(() {
    universities = FakeUniversityRepository(buildUniversities(5));
    profiles = FakeUniversityProfileRepository();
  });

  test('starts loading, then exposes the university and its profile', () async {
    profiles.saveStudentCount(2, 90);
    final viewModel = build();
    expect(viewModel.state.status, UniversityDetailStatus.loading);

    await viewModel.load();

    expect(viewModel.state.status, UniversityDetailStatus.data);
    expect(viewModel.state.university!.id, 2);
    expect(viewModel.state.profile.studentCount, 90);
  });

  test('exposes an error when the university cannot be loaded', () async {
    final viewModel = build(99);

    await viewModel.load();

    expect(viewModel.state.status, UniversityDetailStatus.error);
    expect(viewModel.state.errorMessage, 'University not found');
  });

  test('assigns the picked image', () async {
    final viewModel = build();
    await viewModel.load();

    await viewModel.pickImage(PhotoSource.gallery);

    expect(viewModel.state.profile.imagePath, '/tmp/picked.png');
    expect(viewModel.state.imageError, isNull);
  });

  test('keeps the data and reports a picker failure', () async {
    final viewModel = build();
    await viewModel.load();
    profiles.failPick = true;

    await viewModel.pickImage(PhotoSource.camera);

    expect(viewModel.state.status, UniversityDetailStatus.data);
    expect(viewModel.state.imageError, 'Could not pick the image');
  });

  test('saves a valid student count', () async {
    final viewModel = build();
    await viewModel.load();

    viewModel.submitStudentCount(' 1200 ');

    expect(viewModel.state.profile.studentCount, 1200);
    expect(viewModel.state.studentCountError, isNull);
    expect(profiles.getProfile(2).studentCount, 1200);
  });

  test('does not save an invalid student count', () async {
    final viewModel = build();
    await viewModel.load();
    viewModel.submitStudentCount('50');

    viewModel.submitStudentCount('abc');

    expect(viewModel.state.studentCountError, StudentCountError.notInteger);
    expect(profiles.getProfile(2).studentCount, 50);
  });
}
