import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../universities/providers/universities_list_providers.dart';

part 'splash_providers.g.dart';

/// Shortest time the splash stays visible, so the animation never flickers.
@riverpod
Duration splashMinDuration(Ref ref) => const Duration(milliseconds: 800);

/// Completes when the universities prefetch has finished and the minimum
/// display time has elapsed, whichever happens later.
///
/// A failed prefetch still completes: [universitiesProvider] keeps the error
/// and the list screen shows it with a retry action.
@riverpod
Future<void> splashReady(Ref ref) async {
  final minDuration = ref.watch(splashMinDurationProvider);
  final prefetch = ref
      .watch(universitiesProvider.future)
      .then<void>((_) {}, onError: (Object _) {});
  await Future.wait([Future<void>.delayed(minDuration), prefetch]);
}
