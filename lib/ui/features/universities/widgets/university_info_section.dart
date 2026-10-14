import 'package:flutter/material.dart';

import '../../../../domain/models/university.dart';
import 'info_row.dart';
import 'university_avatar_hero.dart';
import 'university_title_hero.dart';

class UniversityInfoSection extends StatelessWidget {
  const UniversityInfoSection({super.key, required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UniversityAvatarHero(id: university.id, name: university.name),
            const SizedBox(width: 12),
            Expanded(
              child: UniversityTitleHero(
                id: university.id,
                name: university.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InfoRow(label: 'Country', value: university.country),
        if (university.stateProvince != null)
          InfoRow(label: 'State/Province', value: university.stateProvince!),
        if (university.domains.isNotEmpty)
          InfoRow(label: 'Domains', value: university.domains.join(', ')),
        if (university.webPages.isNotEmpty)
          InfoRow(label: 'Web pages', value: university.webPages.join('\n')),
      ],
    );
  }
}
