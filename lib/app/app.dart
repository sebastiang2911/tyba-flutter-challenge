import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';
import 'theme.dart';

class App extends StatelessWidget {
  App({super.key, GoRouter? router}) : _router = router ?? buildRouter();

  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Universities',
      theme: buildAppTheme(),
      routerConfig: _router,
    );
  }
}
