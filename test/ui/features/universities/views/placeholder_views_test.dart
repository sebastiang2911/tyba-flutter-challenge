import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/ui/features/universities/views/university_detail_view.dart';

void main() {
  testWidgets('UniversityDetailView shows the given id', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UniversityDetailView(id: 7)),
    );

    expect(find.text('University detail #7'), findsOneWidget);
  });
}
