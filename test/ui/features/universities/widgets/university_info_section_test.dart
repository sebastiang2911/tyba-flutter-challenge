import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/models/university.dart';
import 'package:tyba_technical_test/ui/features/universities/widgets/university_info_section.dart';

Future<void> _pump(WidgetTester tester, University university) =>
    tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: UniversityInfoSection(university: university)),
      ),
    );

void main() {
  testWidgets('shows every field when present', (tester) async {
    await _pump(
      tester,
      const University(
        id: 1,
        name: 'Tyba University',
        country: 'Colombia',
        alphaTwoCode: 'CO',
        stateProvince: 'Bogota',
        domains: ['a.edu', 'b.edu'],
        webPages: ['https://a.edu'],
      ),
    );

    expect(find.textContaining('Country: Colombia'), findsOneWidget);
    expect(find.textContaining('State/Province: Bogota'), findsOneWidget);
    expect(find.textContaining('Domains: a.edu, b.edu'), findsOneWidget);
    expect(find.textContaining('Web pages: https://a.edu'), findsOneWidget);
  });

  testWidgets('hides absent optional fields', (tester) async {
    await _pump(
      tester,
      const University(
        id: 1,
        name: 'Tyba University',
        country: 'Colombia',
        alphaTwoCode: 'CO',
        domains: [],
        webPages: [],
      ),
    );

    expect(find.textContaining('Country: Colombia'), findsOneWidget);
    expect(find.textContaining('State/Province'), findsNothing);
    expect(find.textContaining('Domains'), findsNothing);
    expect(find.textContaining('Web pages'), findsNothing);
  });
}
