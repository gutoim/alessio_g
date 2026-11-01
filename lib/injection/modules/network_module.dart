import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/api_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Registers third-party networking classes, which can't be annotated directly.
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
      ),
    );

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
