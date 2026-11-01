import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/api_config.dart';
import 'package:dummy_shop/data/network/auth_interceptor.dart';
import 'package:dummy_shop/data/network/dio_names.dart';
import 'package:dummy_shop/data/network/token_refresh_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Registers third-party networking classes, which can't be annotated directly.
@module
abstract class NetworkModule {
  /// The client every API uses: adds the access token and refreshes it on 401.
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    TokenRefreshInterceptor tokenRefreshInterceptor,
  ) => _createDio(interceptors: [authInterceptor, tokenRefreshInterceptor]);

  /// See [DioNames.plain].
  @lazySingleton
  @Named(DioNames.plain)
  Dio plainDio() => _createDio();

  Dio _createDio({List<Interceptor> interceptors = const []}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
      ),
    )..interceptors.addAll(interceptors);

    if (kDebugMode) {
      dio.interceptors.add(
        // Logs URLs, status codes and errors only. Headers and bodies are left
        // out because they carry the access token and the login password.
        LogInterceptor(
          request: false,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }

    return dio;
  }
}
