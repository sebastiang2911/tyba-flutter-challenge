import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../domain/models/university.dart';
import '../../../core/skeleton.dart';
import '../../../core/state_views.dart';
import '../providers/providers.dart';
import 'university_avatar_hero.dart';
import 'university_title_hero.dart';

class UniversitiesListView extends ConsumerWidget {
  const UniversitiesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: _UniversitiesContent(
                  key: ValueKey(layout),
                  layout: layout,
                ),
              ),
      ),
    );
  }
}

/// One scrollable per layout, each with its own controller so both can coexist
/// while the layout switch cross-fades.
class _UniversitiesContent extends ConsumerStatefulWidget {
  const _UniversitiesContent({super.key, required this.layout});

  final UniversitiesLayout layout;

  @override
  ConsumerState<_UniversitiesContent> createState() =>
      _UniversitiesContentState();
}

class _UniversitiesContentState extends ConsumerState<_UniversitiesContent> {
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
    final visible = ref.watch(visibleUniversitiesProvider);
    final items = visible.items;
    const loadMore = Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator()),
    );
    if (widget.layout == UniversitiesLayout.grid) {
      return CustomScrollView(
        controller: _controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisExtent: 120,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _UniversityCard(university: items[index]),
            ),
          ),
          if (visible.hasMore) const SliverToBoxAdapter(child: loadMore),
        ],
      );
    }
    return ListView.builder(
      controller: _controller,
      itemCount: items.length + (visible.hasMore ? 1 : 0),
      itemBuilder: (context, index) => index == items.length
          ? loadMore
          : _UniversityTile(university: items[index]),
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
      leading: UniversityAvatarHero(id: university.id, name: university.name),
      title: UniversityTitleHero(id: university.id, name: university.name),
      subtitle: Text(university.country),
      trailing: const Icon(Icons.chevron_right),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UniversityAvatarHero(
                    id: university.id,
                    name: university.name,
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: UniversityTitleHero(
                      id: university.id,
                      name: university.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 3,
                    ),
                  ),
                ],
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
