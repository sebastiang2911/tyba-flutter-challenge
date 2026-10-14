import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../domain/models/university.dart';
import '../providers/providers.dart';
import 'load_more_indicator.dart';
import 'university_card.dart';
import 'university_tile.dart';

/// One scrollable per layout, each with its own controller so both can coexist
/// while the layout switch cross-fades.
class UniversitiesContent extends ConsumerStatefulWidget {
  const UniversitiesContent({super.key, required this.layout});

  final UniversitiesLayout layout;

  @override
  ConsumerState<UniversitiesContent> createState() =>
      _UniversitiesContentState();
}

class _UniversitiesContentState extends ConsumerState<UniversitiesContent> {
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

  void _openDetail(University university) =>
      context.push(AppRoutes.detailFor(university.id));

  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(visibleUniversitiesProvider);
    final items = visible.items;
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
              itemBuilder: (context, index) => UniversityCard(
                university: items[index],
                onTap: () => _openDetail(items[index]),
              ),
            ),
          ),
          if (visible.hasMore)
            const SliverToBoxAdapter(child: LoadMoreIndicator()),
        ],
      );
    }
    return ListView.builder(
      controller: _controller,
      itemCount: items.length + (visible.hasMore ? 1 : 0),
      itemBuilder: (context, index) => index == items.length
          ? const LoadMoreIndicator()
          : UniversityTile(
              university: items[index],
              onTap: () => _openDetail(items[index]),
            ),
    );
  }
}
