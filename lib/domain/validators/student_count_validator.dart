enum StudentCountError { empty, notInteger, outOfRange }

abstract final class StudentCountValidator {
  static const min = 1;
  static const max = 10000000;

  static final _integer = RegExp(r'^-?\d+$');

  /// Returns the first problem found in [input], or `null` when it is valid.
  static StudentCountError? validate(String? input) {
    final value = input?.trim() ?? '';
    if (value.isEmpty) return StudentCountError.empty;
    if (!_integer.hasMatch(value)) return StudentCountError.notInteger;
    // BigInt keeps absurdly long digit strings out-of-range instead of invalid.
    final number = BigInt.parse(value);
    if (number < BigInt.from(min) || number > BigInt.from(max)) {
      return StudentCountError.outOfRange;
    }
    return null;
  }
}
