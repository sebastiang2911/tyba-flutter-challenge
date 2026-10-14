import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../providers/splash_providers.dart';

/// First in-app screen: shows the animated wordmark while the universities
/// prefetch and the minimum display time run, then replaces itself with the
/// list.
class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  static const _animationDuration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashReadyProvider, (_, next) {
      // Skip if another route already replaced the splash (it can stay mounted
      // while that route's transition runs).
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
      if (isCurrent && (next.hasValue || next.hasError)) {
        context.go(AppRoutes.list);
      }
    });

    final animate = !MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: animate ? 0 : 1, end: 1),
          duration: animate ? _animationDuration : Duration.zero,
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.scale(scale: 0.9 + 0.1 * value, child: child),
          ),
          child: Image.asset(
            'assets/images/tyba_wordmark.png',
            width: 240,
            semanticLabel: 'Tyba',
          ),
        ),
      ),
    );
  }
}
