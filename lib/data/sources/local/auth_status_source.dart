import 'dart:async';

import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:injectable/injectable.dart';

/// In-memory broadcast of session changes.
///
/// Kept separate from the repository so other data-layer classes (the token
/// refresh interceptor) can report an expired session without depending on
/// the repository, which would create a dependency cycle through Dio.
@lazySingleton
class AuthStatusSource {
  final StreamController<AuthStatus> _changes =
      StreamController<AuthStatus>.broadcast();

  /// Status changes only. The initial status comes from secure storage.
  Stream<AuthStatus> get changes => _changes.stream;

  void add(AuthStatus status) => _changes.add(status);

  @disposeMethod
  Future<void> dispose() => _changes.close();
}
