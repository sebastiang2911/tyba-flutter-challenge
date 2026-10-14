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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: UniversityAvatarHero(
          id: university.id,
          name: university.name,
          radius: 24,
        ),
        title: UniversityTitleHero(
          id: university.id,
          name: university.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(university.country),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
