import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/validators/student_count_validator.dart';

void main() {
  StudentCountError? validate(String? input) =>
      StudentCountValidator.validate(input);

  test('accepts integers inside the range, ignoring whitespace', () {
    expect(validate('1'), isNull);
    expect(validate(' 1500 '), isNull);
    expect(validate('10000000'), isNull);
  });

  test('rejects null and blank input as empty', () {
    expect(validate(null), StudentCountError.empty);
    expect(validate(''), StudentCountError.empty);
    expect(validate('   '), StudentCountError.empty);
  });

  test('rejects non-integers', () {
    expect(validate('abc'), StudentCountError.notInteger);
    expect(validate('12.5'), StudentCountError.notInteger);
    expect(validate('1e3'), StudentCountError.notInteger);
  });

  test('rejects values outside 1..10,000,000', () {
    expect(validate('0'), StudentCountError.outOfRange);
    expect(validate('-4'), StudentCountError.outOfRange);
    expect(validate('10000001'), StudentCountError.outOfRange);
    expect(validate('99999999999999999999999'), StudentCountError.outOfRange);
  });
}
