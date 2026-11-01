import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:injectable/injectable.dart';

/// Adds `Authorization: Bearer <access token>` to every request while a
/// session is stored.
@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final tokens = await _tokenStorage.read();
      if (tokens != null) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      }
    } catch (error, stackTrace) {
      // Without a readable token the request still goes out. A protected
      // endpoint then answers 401, which the app handles as an ended session.
      developer.log(
        'Could not read the access token',
        name: 'auth',
        error: error,
        stackTrace: stackTrace,
      );
    }
    handler.next(options);
  }
}
