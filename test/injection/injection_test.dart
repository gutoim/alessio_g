import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/api_config.dart';
import 'package:dummy_shop/data/network/auth_interceptor.dart';
import 'package:dummy_shop/data/network/dio_names.dart';
import 'package:dummy_shop/data/network/token_refresh_interceptor.dart';
import 'package:dummy_shop/data/repositories/auth_repository_impl.dart';
import 'package:dummy_shop/data/repositories/product_repository_impl.dart';
import 'package:dummy_shop/domain/repositories/auth_repository.dart';
import 'package:dummy_shop/domain/repositories/product_repository.dart';
import 'package:dummy_shop/domain/use_cases/login_use_case.dart';
import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:dummy_shop/presentation/products/bloc/products_bloc.dart';
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

  test('binds ProductRepository to its implementation', () {
    expect(getIt<ProductRepository>(), isA<ProductRepositoryImpl>());
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

  test('creates a fresh ProductsBloc for every product list', () async {
    final first = getIt<ProductsBloc>();
    final second = getIt<ProductsBloc>();
    addTearDown(() => Future.wait([first.close(), second.close()]));

    expect(first, isNot(same(second)));
  });

  test('creates a fresh ProductDetailBloc for every detail page', () async {
    final first = getIt<ProductDetailBloc>();
    final second = getIt<ProductDetailBloc>();
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

    test('adds the access token and refreshes it when it expires', () {
      final interceptors = getIt<Dio>().interceptors;

      expect(interceptors.whereType<AuthInterceptor>(), hasLength(1));
      expect(interceptors.whereType<TokenRefreshInterceptor>(), hasLength(1));
    });

    test('the plain client used for refresh has no auth interceptors', () {
      final plain = getIt<Dio>(instanceName: DioNames.plain);

      expect(plain, isNot(same(getIt<Dio>())));
      expect(plain.interceptors.whereType<AuthInterceptor>(), isEmpty);
      expect(plain.interceptors.whereType<TokenRefreshInterceptor>(), isEmpty);
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
