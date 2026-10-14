import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/app.dart';

import '../support/fake_university_repository.dart';

void main() {
  testWidgets('boots to the universities list', (tester) async {
    final repository = FakeUniversityRepository(buildUniversities(3));

    await tester.pumpWidget(App(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('University 0'), findsOneWidget);
  });
}
