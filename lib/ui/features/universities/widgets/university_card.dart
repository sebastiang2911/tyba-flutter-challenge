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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UniversityAvatarHero(
                    id: university.id,
                    name: university.name,
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: UniversityTitleHero(
                      id: university.id,
                      name: university.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(university.country),
            ],
          ),
        ),
      ),
    );
  }
}
