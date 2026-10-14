import 'package:go_router/go_router.dart';

import '../ui/features/universities/views/universities_list_view.dart';
import '../ui/features/universities/views/university_detail_view.dart';

abstract final class AppRoutes {
  static const list = '/';
  static const detail = '/university/:id';

  static String detailFor(int id) => '/university/$id';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.list,
    routes: [
      GoRoute(
        path: AppRoutes.list,
        builder: (context, state) => const UniversitiesListView(),
      ),
      GoRoute(
        path: AppRoutes.detail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return UniversityDetailView(id: id);
        },
      ),
    ],
  );
}
