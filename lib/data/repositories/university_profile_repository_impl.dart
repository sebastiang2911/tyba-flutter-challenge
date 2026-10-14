import '../../domain/failures/failure.dart';
import '../../domain/models/university_profile.dart';
import '../../domain/repositories/university_profile_repository.dart';
import '../services/image_picker_service.dart';

/// Keeps profiles in memory only; nothing survives an app restart.
class InMemoryUniversityProfileRepository
    implements UniversityProfileRepository {
  InMemoryUniversityProfileRepository(this._picker);

  final ImagePickerService _picker;
  final _profiles = <int, UniversityProfile>{};

  @override
  UniversityProfile getProfile(int universityId) =>
      _profiles[universityId] ?? const UniversityProfile();

  @override
  UniversityProfile saveStudentCount(int universityId, int count) =>
      _profiles[universityId] = getProfile(universityId)
          .copyWith(studentCount: count);

  @override
  Future<UniversityProfile> pickImage(
    int universityId,
    PhotoSource source,
  ) async {
    final String? path;
    try {
      path = await _picker.pick(source);
    } catch (_) {
      throw const Failure('Could not pick the image');
    }
    if (path == null) return getProfile(universityId);
    return _profiles[universityId] = getProfile(universityId)
        .copyWith(imagePath: path);
  }
}
