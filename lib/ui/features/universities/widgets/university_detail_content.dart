import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/university.dart';
import '../providers/providers.dart';
import 'student_count_section.dart';
import 'university_image_section.dart';
import 'university_info_section.dart';

class UniversityDetailContent extends ConsumerWidget {
  const UniversityDetailContent({
    super.key,
    required this.id,
    required this.university,
  });

  final int id;
  final University university;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(universityProfileProvider(id));
    final notifier = ref.read(universityProfileProvider(id).notifier);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        UniversityImageSection(
          imagePath: state.profile.imagePath,
          error: state.imageError,
          onPick: notifier.pickImage,
        ),
        const SizedBox(height: 16),
        UniversityInfoSection(university: university),
        const SizedBox(height: 16),
        StudentCountSection(
          initialValue: state.profile.studentCount,
          error: state.studentCountError,
          onSubmit: notifier.submitStudentCount,
        ),
      ],
    );
  }
}
