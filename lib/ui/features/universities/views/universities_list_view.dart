import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../domain/failures/failure.dart';
import '../../../../domain/models/university.dart';
import '../providers/providers.dart';

class UniversitiesListView extends ConsumerStatefulWidget {
  const UniversitiesListView({super.key});

  @override
  ConsumerState<UniversitiesListView> createState() =>
      _UniversitiesListViewState();
}

class _UniversitiesListViewState extends ConsumerState<UniversitiesListView> {
  /// Distance from the end of the content (px) that triggers the next page.
  static const _loadMoreThreshold = 200.0;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.extentAfter < _loadMoreThreshold) {
      ref.read(visibleCountProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final universities = ref.watch(universitiesProvider);
    final layout = ref.watch(universitiesLayoutProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities'),
        actions: [
          IconButton(
            tooltip: layout == UniversitiesLayout.list
                ? 'Show grid'
                : 'Show list',
            icon: Icon(
              layout == UniversitiesLayout.list
                  ? Icons.grid_view
                  : Icons.view_list,
            ),
            onPressed: ref.read(universitiesLayoutProvider.notifier).toggle,
          ),
        ],
      ),
      body: universities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error is Failure ? error.message : 'Something went wrong'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(universitiesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (all) => all.isEmpty
            ? const Center(child: Text('No universities found'))
            : _UniversitiesContent(layout: layout, controller: _controller),
      ),
    );
  }
}

class _UniversitiesContent extends ConsumerWidget {
  const _UniversitiesContent({required this.layout, required this.controller});

  final UniversitiesLayout layout;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(visibleUniversitiesProvider).items;
    if (layout == UniversitiesLayout.grid) {
      return GridView.builder(
        controller: controller,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisExtent: 120,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) =>
            _UniversityCard(university: items[index]),
      );
    }
    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _UniversityTile(university: items[index]),
    );
  }
}

void _openDetail(BuildContext context, University university) =>
    context.push(AppRoutes.detailFor(university.id));

class _UniversityTile extends StatelessWidget {
  const _UniversityTile({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(university.name),
      subtitle: Text(university.country),
      onTap: () => _openDetail(context, university),
    );
  }
}

class _UniversityCard extends StatelessWidget {
  const _UniversityCard({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(context, university),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                university.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text(university.country),
            ],
          ),
        ),
      ),
    );
  }
}
