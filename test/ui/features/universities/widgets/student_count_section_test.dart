import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/validators/student_count_validator.dart';
import 'package:tyba_technical_test/ui/features/universities/widgets/student_count_section.dart';

Widget _wrap({
  int? initialValue,
  StudentCountError? error,
  required bool Function(String) onSubmit,
}) => MaterialApp(
  home: Scaffold(
    body: StudentCountSection(
      initialValue: initialValue,
      error: error,
      onSubmit: onSubmit,
    ),
  ),
);

void main() {
  testWidgets('prefills the initial value', (tester) async {
    await tester.pumpWidget(_wrap(initialValue: 1200, onSubmit: (_) => true));

    expect(find.text('1200'), findsOneWidget);
  });

  testWidgets('shows the message for each validation error', (tester) async {
    final messages = {
      StudentCountError.empty: 'Enter the number of students',
      StudentCountError.notInteger: 'Must be a whole number',
      StudentCountError.outOfRange:
          'Must be between ${StudentCountValidator.min} and '
          '${StudentCountValidator.max}',
    };
    for (final entry in messages.entries) {
      await tester.pumpWidget(_wrap(error: entry.key, onSubmit: (_) => false));
      expect(find.text(entry.value), findsOneWidget);
    }
  });

  testWidgets('submits the typed value and confirms with a snackbar', (
    tester,
  ) async {
    String? submitted;
    await tester.pumpWidget(
      _wrap(
        onSubmit: (value) {
          submitted = value;
          return true;
        },
      ),
    );

    await tester.enterText(find.byType(TextField), '500');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(submitted, '500');
    expect(find.text('Student count saved'), findsOneWidget);
  });

  testWidgets('shows no snackbar when the submit is rejected', (tester) async {
    await tester.pumpWidget(_wrap(onSubmit: (_) => false));

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Student count saved'), findsNothing);
  });
}
