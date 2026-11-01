import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/api_config.dart';
import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('registers AppRouter as a singleton', () {
    expect(getIt<AppRouter>(), same(getIt<AppRouter>()));
  });

  group('Dio', () {
    test('is a singleton configured for the DummyJSON API', () {
      final dio = getIt<Dio>();

      expect(dio, same(getIt<Dio>()));
      expect(dio.options.baseUrl, 'https://dummyjson.com');
      expect(dio.options.connectTimeout, ApiConfig.connectTimeout);
      expect(dio.options.receiveTimeout, ApiConfig.receiveTimeout);
    });

    test('debug logging never prints headers or bodies', () {
      final logger = getIt<Dio>().interceptors
          .whereType<LogInterceptor>()
          .single;

      expect(logger.requestHeader, isFalse);
      expect(logger.requestBody, isFalse);
      expect(logger.responseHeader, isFalse);
      expect(logger.responseBody, isFalse);
    });
  });
}
