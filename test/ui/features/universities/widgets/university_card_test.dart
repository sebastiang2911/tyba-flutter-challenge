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
            height: 180,
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

  testWidgets('long name does not overflow at large text scale', (
    tester,
  ) async {
    const long = University(
      id: 4,
      name: 'Chabot-Las Positas Community College District of California',
      country: 'United States',
      alphaTwoCode: 'US',
      domains: ['x.edu'],
      webPages: ['https://x.edu'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SizedBox(
              width: 180,
              height: 360,
              child: UniversityCard(university: long, onTap: () {}),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
