import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/app.dart';

void main() {
  testWidgets('boots to the list placeholder', (tester) async {
    await tester.pumpWidget(App());

    expect(find.text('Universities list'), findsOneWidget);
  });
}
