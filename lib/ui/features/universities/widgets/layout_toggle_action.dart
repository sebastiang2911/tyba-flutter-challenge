import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class LayoutToggleAction extends ConsumerWidget {
  const LayoutToggleAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(universitiesLayoutProvider);
    return IconButton(
      tooltip: layout == UniversitiesLayout.list ? 'Show grid' : 'Show list',
      icon: Icon(
        layout == UniversitiesLayout.list ? Icons.grid_view : Icons.view_list,
      ),
      onPressed: ref.read(universitiesLayoutProvider.notifier).toggle,
    );
  }
}
