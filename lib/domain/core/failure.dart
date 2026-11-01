import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Why an operation failed, in terms the presentation layer can act on.
///
/// The data layer converts transport errors (Dio, JSON parsing) into one of
/// these cases, so nothing above it ever sees a `DioException`.
@freezed
sealed class Failure with _$Failure {
  /// No connection, DNS or TLS failure, or a timeout.
  const factory Failure.network() = NetworkFailure;

  /// The username or password was rejected at login.
  const factory Failure.invalidCredentials() = InvalidCredentialsFailure;

  /// Missing, invalid or expired access token (HTTP 401).
  const factory Failure.unauthorized() = UnauthorizedFailure;

  /// The requested resource does not exist (HTTP 404).
  const factory Failure.notFound() = NotFoundFailure;

  /// Any other HTTP error. [message] is the API's `message` field, if present.
  const factory Failure.server({int? statusCode, String? message}) =
      ServerFailure;

  /// Anything unexpected, such as a malformed response.
  const factory Failure.unknown() = UnknownFailure;
}
