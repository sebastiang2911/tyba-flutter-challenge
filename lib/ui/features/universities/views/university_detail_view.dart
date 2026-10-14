import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../core/state_views.dart';
import '../providers/providers.dart';
import '../widgets/university_detail_content.dart';

class UniversityDetailView extends ConsumerWidget {
  const UniversityDetailView({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final university = ref.watch(universityProvider(id));
    return PopScope(
      // Deep link: nothing below the detail, so go to the list on back.
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRoutes.list);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.list),
          ),
          title: Text(university.value?.name ?? 'University'),
        ),
        body: university.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView.from(
            error,
            onRetry: () => ref.invalidate(universityProvider(id)),
          ),
          data: (university) =>
              UniversityDetailContent(id: id, university: university),
        ),
      ),
    );
  }
}
