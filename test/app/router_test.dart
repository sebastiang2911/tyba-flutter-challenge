import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tyba_technical_test/app/app.dart';
import 'package:tyba_technical_test/app/router.dart';

import '../support/fake_university_repository.dart';
import '../support/fake_university_profile_repository.dart';

Future<GoRouter> _pump(WidgetTester tester) async {
  final router = buildRouter();
  await tester.pumpWidget(
    App(
      repository: FakeUniversityRepository(buildUniversities(10)),
      profileRepository: FakeUniversityProfileRepository(),
      router: router,
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('starts on the list route', (tester) async {
    await _pump(tester);

    expect(find.text('University 0'), findsOneWidget);
  });

  testWidgets('resolves the detail route with its id', (tester) async {
    final router = await _pump(tester);

    router.go('/university/3');
    await tester.pumpAndSettle();

    expect(find.text('University 3'), findsWidgets);
  });

  testWidgets('detailFor builds a path that resolves to that id', (
    tester,
  ) async {
    final router = await _pump(tester);

    router.go(AppRoutes.detailFor(7));
    await tester.pumpAndSettle();

    expect(find.text('University 7'), findsWidgets);
  });
}
