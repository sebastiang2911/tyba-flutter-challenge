/// Where a picture comes from.
enum PhotoSource { gallery, camera }

/// Session-only data the user assigns to a university.
class UniversityProfile {
  const UniversityProfile({this.imagePath, this.studentCount});

  final String? imagePath;
  final int? studentCount;

  UniversityProfile copyWith({String? imagePath, int? studentCount}) {
    return UniversityProfile(
      imagePath: imagePath ?? this.imagePath,
      studentCount: studentCount ?? this.studentCount,
    );
  }
}
