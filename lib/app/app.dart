import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/repositories/university_repository.dart';
import '../ui/features/universities/view_models/universities_list_view_model.dart';
import 'router.dart';
import 'theme.dart';

class App extends StatelessWidget {
  App({super.key, required this.repository, GoRouter? router})
    : _router = router ?? buildRouter();

  final UniversityRepository repository;
  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return Provider<UniversityRepository>.value(
      value: repository,
      child: ChangeNotifierProvider(
        create: (context) =>
            UniversitiesListViewModel(context.read<UniversityRepository>())
              ..load(),
        child: MaterialApp.router(
          title: 'Universities',
          theme: buildAppTheme(),
          routerConfig: _router,
        ),
      ),
    );
  }
}
