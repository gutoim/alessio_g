import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/api_config.dart';
import 'package:dummy_shop/data/network/auth_interceptor.dart';
import 'package:dummy_shop/data/repositories/auth_repository_impl.dart';
import 'package:dummy_shop/domain/repositories/auth_repository.dart';
import 'package:dummy_shop/domain/use_cases/login_use_case.dart';
import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('registers AppRouter as a singleton', () {
    expect(getIt<AppRouter>(), same(getIt<AppRouter>()));
  });

  test('shares one SessionBloc between the app and the router', () {
    expect(getIt<SessionBloc>(), same(getIt<SessionBloc>()));
  });

  test('binds AuthRepository to its implementation, as a singleton', () {
    expect(getIt<AuthRepository>(), isA<AuthRepositoryImpl>());
    expect(getIt<AuthRepository>(), same(getIt<AuthRepository>()));
  });

  test('creates a new use case on every lookup', () {
    expect(getIt<LoginUseCase>(), isNot(same(getIt<LoginUseCase>())));
  });

  test('creates a fresh LoginBloc for every login screen', () async {
    final first = getIt<LoginBloc>();
    final second = getIt<LoginBloc>();
    addTearDown(() => Future.wait([first.close(), second.close()]));

    expect(first, isNot(same(second)));
  });

  group('Dio', () {
    test('is a singleton configured for the DummyJSON API', () {
      final dio = getIt<Dio>();

      expect(dio, same(getIt<Dio>()));
      expect(dio.options.baseUrl, 'https://dummyjson.com');
      expect(dio.options.connectTimeout, ApiConfig.connectTimeout);
      expect(dio.options.receiveTimeout, ApiConfig.receiveTimeout);
    });

    test('adds the access token to requests', () {
      expect(
        getIt<Dio>().interceptors.whereType<AuthInterceptor>(),
        hasLength(1),
      );
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
