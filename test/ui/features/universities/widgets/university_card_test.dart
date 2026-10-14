import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/models/university.dart';
import 'package:tyba_technical_test/ui/features/universities/widgets/university_card.dart';

const _university = University(
  id: 3,
  name: 'Tyba University',
  country: 'Colombia',
  alphaTwoCode: 'CO',
  domains: ['tyba.edu'],
  webPages: ['https://tyba.edu'],
);

void main() {
  testWidgets('shows name and country and reports taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 120,
            child: UniversityCard(university: _university, onTap: () => taps++),
          ),
        ),
      ),
    );

    expect(find.text('Tyba University'), findsOneWidget);
    expect(find.text('Colombia'), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });
}
