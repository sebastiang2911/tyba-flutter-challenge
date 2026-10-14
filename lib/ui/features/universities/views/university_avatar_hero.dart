import 'package:flutter/material.dart';

/// University initial that flies from the list item to the detail header.
class UniversityAvatarHero extends StatelessWidget {
  const UniversityAvatarHero({
    super.key,
    required this.id,
    required this.name,
    this.radius,
  });

  final int id;
  final String name;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Hero(
      tag: 'university-$id-avatar',
      // Text needs a Material ancestor during the flight to keep its style.
      child: Material(
        type: MaterialType.transparency,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Text(name.characters.first.toUpperCase()),
        ),
      ),
    );
  }
}
