import 'package:flutter/material.dart';

/// University name that flies from the list item to the detail header.
class UniversityTitleHero extends StatelessWidget {
  const UniversityTitleHero({
    super.key,
    required this.id,
    required this.name,
    this.style,
    this.maxLines,
    this.textAlign,
  });

  final int id;
  final String name;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;

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
          textAlign: textAlign,
          overflow: maxLines == null ? null : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
