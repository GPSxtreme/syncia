class ExceptionMessage implements Exception {
  final String message;

  ExceptionMessage(this.message);

  @override
  String toString() => message;
}

void functionThatThrows() {
  throw ExceptionMessage('This is a custom exception');
}
