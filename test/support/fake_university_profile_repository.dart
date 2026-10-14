import 'dart:async';

import 'package:tyba_technical_test/domain/failures/failure.dart';
import 'package:tyba_technical_test/domain/models/university_profile.dart';
import 'package:tyba_technical_test/domain/repositories/university_profile_repository.dart';

class FakeUniversityProfileRepository implements UniversityProfileRepository {
  final profiles = <int, UniversityProfile>{};

  /// Path returned by the next pick; `null` simulates a cancelled picker.
  String? nextPickedPath = '/tmp/picked.png';

  /// Makes the next pick fail.
  bool failPick = false;

  /// When set, the next pick waits for it before resolving.
  Completer<void>? pickGate;

  @override
  UniversityProfile getProfile(int universityId) =>
      profiles[universityId] ?? const UniversityProfile();

  @override
  UniversityProfile saveStudentCount(int universityId, int count) =>
      profiles[universityId] = getProfile(universityId)
          .copyWith(studentCount: count);

  @override
  Future<UniversityProfile> pickImage(
    int universityId,
    PhotoSource source,
  ) async {
    await pickGate?.future;
    if (failPick) throw const Failure('Could not pick the image');
    final path = nextPickedPath;
    if (path == null) return getProfile(universityId);
    return profiles[universityId] = getProfile(universityId)
        .copyWith(imagePath: path);
  }
}
