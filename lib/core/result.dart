/// A discriminated union representing the outcome of any use-case or
/// repository call.
///
/// Use [Success] for happy-path results and [Failure] for any error condition.
/// Pattern-match exhaustively in the controller:
///
/// ```dart
/// switch (result) {
///   case Success(:final data):   // use data
///   case Failure(:final message): // show error
/// }
/// ```
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
