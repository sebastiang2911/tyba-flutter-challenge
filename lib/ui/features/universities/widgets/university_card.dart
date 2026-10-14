import 'package:flutter/material.dart';

import '../../../../domain/models/university.dart';
import 'university_avatar_hero.dart';
import 'university_title_hero.dart';

class UniversityCard extends StatelessWidget {
  const UniversityCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  final University university;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UniversityAvatarHero(
                id: university.id,
                name: university.name,
                radius: 28,
              ),
              const SizedBox(height: 12),
              UniversityTitleHero(
                id: university.id,
                name: university.name,
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                university.country,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
