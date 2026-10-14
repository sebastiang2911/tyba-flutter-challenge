import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/skeleton.dart';
import '../../../core/state_views.dart';
import '../providers/providers.dart';
import '../widgets/layout_toggle_action.dart';
import '../widgets/universities_content.dart';

class UniversitiesListView extends ConsumerWidget {
  const UniversitiesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universities = ref.watch(universitiesProvider);
    final layout = ref.watch(universitiesLayoutProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities'),
        actions: const [LayoutToggleAction()],
      ),
      body: universities.when(
        loading: () => const ListSkeleton(),
        error: (error, _) => ErrorView.from(
          error,
          onRetry: () => ref.invalidate(universitiesProvider),
        ),
        data: (all) => all.isEmpty
            ? const EmptyView(message: 'No universities found')
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                layoutBuilder: (current, previous) => Stack(
                  fit: StackFit.expand,
                  children: [...previous, ?current],
                ),
                child: UniversitiesContent(
                  key: ValueKey(layout),
                  layout: layout,
                ),
              ),
      ),
    );
  }
}
