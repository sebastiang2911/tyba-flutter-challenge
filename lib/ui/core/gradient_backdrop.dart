import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Indigo that continues the app bar and fades into the surface color
/// toward the bottom, so content cards float over a soft gradient.
class GradientBackdrop extends StatelessWidget {
  const GradientBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [universityIndigo, Theme.of(context).colorScheme.surface],
          stops: const [0, 0.45],
        ),
      ),
      child: child,
    );
  }
}
