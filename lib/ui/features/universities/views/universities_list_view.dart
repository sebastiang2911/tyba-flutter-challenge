import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router.dart';
import '../../../../domain/models/university.dart';
import '../view_models/universities_list_view_model.dart';

class UniversitiesListView extends StatefulWidget {
  const UniversitiesListView({super.key});

  @override
  State<UniversitiesListView> createState() => _UniversitiesListViewState();
}

class _UniversitiesListViewState extends State<UniversitiesListView> {
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
      context.read<UniversitiesListViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<UniversitiesListViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Universities'),
            actions: [
              IconButton(
                tooltip: state.layout == UniversitiesLayout.list
                    ? 'Show grid'
                    : 'Show list',
                icon: Icon(
                  state.layout == UniversitiesLayout.list
                      ? Icons.grid_view
                      : Icons.view_list,
                ),
                onPressed: viewModel.toggleLayout,
              ),
            ],
          ),
          body: switch (state.status) {
            UniversitiesListStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            UniversitiesListStatus.error => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Something went wrong'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: viewModel.load,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            UniversitiesListStatus.empty => const Center(
              child: Text('No universities found'),
            ),
            UniversitiesListStatus.data => _UniversitiesContent(
              state: state,
              controller: _controller,
            ),
          },
        );
      },
    );
  }
}

class _UniversitiesContent extends StatelessWidget {
  const _UniversitiesContent({required this.state, required this.controller});

  final UniversitiesListState state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final items = state.visible;
    if (state.layout == UniversitiesLayout.grid) {
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
    context.go(AppRoutes.detailFor(university.id));

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
