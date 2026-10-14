/// Domain-level error surfaced to the UI layer.
class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      other is Failure && other.message == message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'Failure($message)';
}
