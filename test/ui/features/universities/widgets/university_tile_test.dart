import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/models/university.dart';
import 'package:tyba_technical_test/ui/features/universities/widgets/university_tile.dart';

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
          body: UniversityTile(university: _university, onTap: () => taps++),
        ),
      ),
    );

    expect(find.text('Tyba University'), findsOneWidget);
    expect(find.text('Colombia'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byType(ListTile));
    expect(taps, 1);
  });
}
