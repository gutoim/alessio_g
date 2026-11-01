import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/domain/entities/user.dart';

/// Authentication and the current session.
abstract interface class AuthRepository {
  /// Emits the current [AuthStatus] when listened to, then every change
  /// caused by [login], [logout] or an expired session.
  Stream<AuthStatus> watchStatus();

  /// Signs in and stores the session securely.
  ///
  /// Fails with `Failure.invalidCredentials` when the API rejects the
  /// username or password.
  Future<Result<User>> login({
    required String username,
    required String password,
  });

  /// Deletes the stored session. Never fails: the user ends up logged out.
  Future<void> logout();
}
