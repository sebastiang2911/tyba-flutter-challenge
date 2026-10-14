import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/failures/failure.dart';
import 'package:tyba_technical_test/ui/core/state_views.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('LoadingView shows a progress indicator', (tester) async {
    await tester.pumpWidget(_wrap(const LoadingView()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ErrorView shows the message and retries', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      _wrap(ErrorView(message: 'Boom', onRetry: () => retries++)),
    );

    expect(find.text('Boom'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
  });

  testWidgets('ErrorView.from uses the Failure message', (tester) async {
    await tester.pumpWidget(
      _wrap(ErrorView.from(const Failure('Not found'), onRetry: () {})),
    );

    expect(find.text('Not found'), findsOneWidget);
  });

  testWidgets('ErrorView.from falls back to a generic message', (tester) async {
    await tester.pumpWidget(
      _wrap(ErrorView.from(StateError('x'), onRetry: () {})),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('EmptyView shows its message', (tester) async {
    await tester.pumpWidget(_wrap(const EmptyView(message: 'Nothing here')));

    expect(find.text('Nothing here'), findsOneWidget);
  });
}
