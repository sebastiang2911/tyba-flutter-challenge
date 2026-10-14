import 'package:flutter/material.dart';

import '../../../../domain/models/university.dart';
import 'university_avatar_hero.dart';
import 'university_title_hero.dart';

class UniversityTile extends StatelessWidget {
  const UniversityTile({
    super.key,
    required this.university,
    required this.onTap,
  });

  final University university;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UniversityAvatarHero(id: university.id, name: university.name),
      title: UniversityTitleHero(id: university.id, name: university.name),
      subtitle: Text(university.country),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
