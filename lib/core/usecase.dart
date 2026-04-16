import 'result.dart';

/// Base contract that every use case must implement.
///
/// [Type]   — the domain type returned, wrapped in [Result].
/// [Params] — input parameters. Use [NoParams] when none are needed.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Placeholder for use cases that require no input.
final class NoParams {
  const NoParams();
}
