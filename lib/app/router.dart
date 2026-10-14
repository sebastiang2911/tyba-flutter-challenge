import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ui/features/splash/views/splash_view.dart';
import '../ui/features/universities/views/universities_list_view.dart';
import '../ui/features/universities/views/university_detail_view.dart';
import 'transitions.dart';

part 'router.g.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const list = '/';
  static const detail = '/university/:id';

  static String detailFor(int id) => '/university/$id';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.list,
        pageBuilder: (context, state) =>
            fadeSlidePage(state: state, child: const UniversitiesListView()),
      ),
      GoRoute(
        path: AppRoutes.detail,
        pageBuilder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return fadeSlidePage(
            state: state,
            child: UniversityDetailView(id: id),
          );
        },
      ),
    ],
  );
}
