import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:dummy_shop/data/models/refresh_token_request_dto.dart';
import 'package:dummy_shop/data/network/dio_names.dart';
import 'package:dummy_shop/data/sources/local/auth_status_source.dart';
import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:dummy_shop/data/sources/remote/token_refresh_api.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:injectable/injectable.dart';

/// On a `401`, gets a new access token with the refresh token and retries the
/// request once.
///
/// - The refresh endpoint rejects the refresh token (4xx): the session is
///   over. Tokens are cleared and [AuthStatus.unauthenticated] is sent, so
///   the router returns to login.
/// - The refresh fails for another reason (offline, 5xx): the session is kept
///   and only the original request fails.
///
/// It is a [QueuedInterceptor], so errors are handled one at a time: when
/// several requests fail together, the first one refreshes and the others
/// retry with the token it stored.
@lazySingleton
class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor(
    this._tokenStorage,
    this._refreshApi,
    this._authStatus,
    @Named(DioNames.plain) this._plainDio,
  );

  final TokenStorage _tokenStorage;
  final TokenRefreshApi _refreshApi;
  final AuthStatusSource _authStatus;

  /// Retries go through the plain client. Going through the main client would
  /// queue the retry's own error behind this handler and deadlock.
  final Dio _plainDio;

  static const String _retriedKey = 'tokenRefresh.retried';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 || request.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    final tokens = await _readTokens();
    if (tokens == null) return handler.next(err);

    final AuthTokens freshTokens;
    if (request.headers['Authorization'] == _bearer(tokens.accessToken)) {
      switch (await _refresh(tokens.refreshToken)) {
        case _Refreshed(:final tokens):
          freshTokens = tokens;
        case _Rejected():
          await _endSession();
          return handler.next(err);
        case _Failed():
          return handler.next(err);
      }
    } else {
      // Another request refreshed the tokens while this one was in flight.
      freshTokens = tokens;
    }

    try {
      final response = await _plainDio.fetch<dynamic>(
        request.copyWith(
          headers: {
            ...request.headers,
            'Authorization': _bearer(freshTokens.accessToken),
          },
          extra: {...request.extra, _retriedKey: true},
        ),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<_RefreshOutcome> _refresh(String refreshToken) async {
    try {
      final response = await _refreshApi.refresh(
        RefreshTokenRequestDto(refreshToken: refreshToken),
      );
      final tokens = response.toTokens();
      await _tokenStorage.save(tokens);
      return _Refreshed(tokens);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      final rejected = status != null && status >= 400 && status < 500;
      _log('Token refresh ${rejected ? 'rejected' : 'failed'}', error);
      return rejected ? const _Rejected() : const _Failed();
    } catch (error, stackTrace) {
      _log('Token refresh failed', error, stackTrace);
      return const _Failed();
    }
  }

  Future<AuthTokens?> _readTokens() async {
    try {
      return await _tokenStorage.read();
    } catch (error, stackTrace) {
      _log('Could not read the stored tokens', error, stackTrace);
      return null;
    }
  }

  Future<void> _endSession() async {
    try {
      await _tokenStorage.clear();
    } catch (error, stackTrace) {
      _log('Could not clear the stored tokens', error, stackTrace);
    }
    _authStatus.add(AuthStatus.unauthenticated);
  }

  static String _bearer(String accessToken) => 'Bearer $accessToken';

  static void _log(String message, Object error, [StackTrace? stackTrace]) =>
      developer.log(
        message,
        name: 'auth',
        error: error,
        stackTrace: stackTrace,
      );
}

sealed class _RefreshOutcome {
  const _RefreshOutcome();
}

final class _Refreshed extends _RefreshOutcome {
  const _Refreshed(this.tokens);

  final AuthTokens tokens;
}

/// The refresh token itself was refused: the session cannot be recovered.
final class _Rejected extends _RefreshOutcome {
  const _Rejected();
}

/// The refresh could not be completed (offline, server error): try later.
final class _Failed extends _RefreshOutcome {
  const _Failed();
}
