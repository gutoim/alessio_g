import 'package:dummy_shop/domain/core/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Outcome of an operation that can fail: either [Ok] with a value or [Err]
/// with a [Failure].
///
/// Repositories and use cases return this instead of throwing, so callers
/// must handle both cases:
///
/// ```dart
/// switch (await getProducts()) {
///   case Ok(:final value): ...
///   case Err(:final failure): ...
/// }
/// ```
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.ok(T value) = Ok<T>;

  const factory Result.err(Failure failure) = Err<T>;
}
