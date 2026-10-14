import 'package:flutter_test/flutter_test.dart';

import '../support/fake_university_repository.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('boots to the universities list', (tester) async {
    await pumpApp(
      tester,
      universities: FakeUniversityRepository(buildUniversities(3)),
    );
    await tester.pumpAndSettle();

    expect(find.text('University 0'), findsOneWidget);
  });
}
