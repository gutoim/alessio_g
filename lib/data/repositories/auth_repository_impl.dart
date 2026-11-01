import 'dart:developer' as developer;

import 'package:dummy_shop/data/models/login_request_dto.dart';
import 'package:dummy_shop/data/network/safe_call.dart';
import 'package:dummy_shop/data/sources/local/auth_status_source.dart';
import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:dummy_shop/data/sources/remote/auth_api.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/domain/entities/user.dart';
import 'package:dummy_shop/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._api, this._tokenStorage, this._authStatus);

  final AuthApi _api;
  final TokenStorage _tokenStorage;
  final AuthStatusSource _authStatus;

  @override
  Stream<AuthStatus> watchStatus() async* {
    // Secure storage is the source of truth for the initial status.
    final tokens = await _tokenStorage.read();
    yield tokens == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    yield* _authStatus.changes;
  }

  @override
  Future<Result<User>> login({
    required String username,
    required String password,
  }) async {
    final result = await safeCall(() async {
      final response = await _api.login(
        LoginRequestDto(username: username, password: password),
      );
      await _tokenStorage.save((
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      ));
      return response.toDomain();
    });

    switch (result) {
      case Ok():
        _authStatus.add(AuthStatus.authenticated);
        return result;
      // On this endpoint a 400 means wrong or missing credentials.
      case Err(failure: ServerFailure(statusCode: 400)):
        return const Result.err(Failure.invalidCredentials());
      case Err():
        return result;
    }
  }

  @override
  Future<void> logout() async {
    // DummyJSON has no logout endpoint: ending the session is local only.
    try {
      await _tokenStorage.clear();
    } catch (error, stackTrace) {
      // Logging out must always succeed for the user, so a storage error is
      // logged instead of being rethrown.
      developer.log(
        'Could not clear the stored tokens',
        name: 'auth',
        error: error,
        stackTrace: stackTrace,
      );
    }
    _authStatus.add(AuthStatus.unauthenticated);
  }
}
