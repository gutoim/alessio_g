import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/l10n/l10n.dart';

/// The localized, user-facing message for a [Failure].
extension FailureMessage on Failure {
  String message(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.failureNetwork,
    InvalidCredentialsFailure() => l10n.failureInvalidCredentials,
    UnauthorizedFailure() => l10n.failureUnauthorized,
    NotFoundFailure() => l10n.failureNotFound,
    ServerFailure() => l10n.failureServer,
    UnknownFailure() => l10n.failureUnknown,
  };
}
