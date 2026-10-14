import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/failures/failure.dart';

void main() {
  test('is equal to a failure with the same message', () {
    expect(const Failure('boom'), const Failure('boom'));
    expect(const Failure('boom').hashCode, const Failure('boom').hashCode);
  });

  test('is different from a failure with another message', () {
    expect(const Failure('boom'), isNot(const Failure('bang')));
  });

  test('is different from other types', () {
    // ignore: unrelated_type_equality_checks
    expect(const Failure('boom') == 'boom', isFalse);
  });

  test('toString includes the message', () {
    expect(const Failure('boom').toString(), 'Failure(boom)');
  });
}
