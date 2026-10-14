import 'package:flutter/material.dart';

/// University name that flies from the list item to the detail header.
class UniversityTitleHero extends StatelessWidget {
  const UniversityTitleHero({
    super.key,
    required this.id,
    required this.name,
    this.style,
    this.maxLines,
  });

  final int id;
  final String name;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'university-$id-title',
      // Text needs a Material ancestor during the flight to keep its style.
      child: Material(
        type: MaterialType.transparency,
        child: Text(
          name,
          style: style,
          maxLines: maxLines,
          overflow: maxLines == null ? null : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
