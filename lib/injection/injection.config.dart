// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:dummy_shop/data/network/auth_interceptor.dart' as _i74;
import 'package:dummy_shop/data/network/token_refresh_interceptor.dart'
    as _i824;
import 'package:dummy_shop/data/repositories/auth_repository_impl.dart'
    as _i694;
import 'package:dummy_shop/data/repositories/product_repository_impl.dart'
    as _i652;
import 'package:dummy_shop/data/sources/local/auth_status_source.dart' as _i159;
import 'package:dummy_shop/data/sources/local/token_storage.dart' as _i363;
import 'package:dummy_shop/data/sources/remote/auth_api.dart' as _i180;
import 'package:dummy_shop/data/sources/remote/product_api.dart' as _i217;
import 'package:dummy_shop/data/sources/remote/token_refresh_api.dart' as _i818;
import 'package:dummy_shop/domain/entities/product.dart' as _i71;
import 'package:dummy_shop/domain/repositories/auth_repository.dart' as _i245;
import 'package:dummy_shop/domain/repositories/product_repository.dart'
    as _i610;
import 'package:dummy_shop/domain/use_cases/get_product_use_case.dart' as _i430;
import 'package:dummy_shop/domain/use_cases/get_products_use_case.dart'
    as _i586;
import 'package:dummy_shop/domain/use_cases/login_use_case.dart' as _i760;
import 'package:dummy_shop/domain/use_cases/logout_use_case.dart' as _i362;
import 'package:dummy_shop/domain/use_cases/watch_auth_status_use_case.dart'
    as _i701;
import 'package:dummy_shop/injection/modules/network_module.dart' as _i794;
import 'package:dummy_shop/injection/modules/storage_module.dart' as _i918;
import 'package:dummy_shop/presentation/app/router/app_router.dart' as _i60;
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart' as _i99;
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_bloc.dart'
    as _i7;
import 'package:dummy_shop/presentation/products/bloc/products_bloc.dart'
    as _i33;
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart'
    as _i235;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i159.AuthStatusSource>(
      () => _i159.AuthStatusSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => storageModule.secureStorage,
    );
    gh.lazySingleton<_i363.TokenStorage>(
      () => _i363.TokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.plainDio(),
      instanceName: 'plainDio',
    );
    gh.lazySingleton<_i74.AuthInterceptor>(
      () => _i74.AuthInterceptor(gh<_i363.TokenStorage>()),
    );
    gh.lazySingleton<_i818.TokenRefreshApi>(
      () => _i818.TokenRefreshApi(gh<_i361.Dio>(instanceName: 'plainDio')),
    );
    gh.lazySingleton<_i824.TokenRefreshInterceptor>(
      () => _i824.TokenRefreshInterceptor(
        gh<_i363.TokenStorage>(),
        gh<_i818.TokenRefreshApi>(),
        gh<_i159.AuthStatusSource>(),
        gh<_i361.Dio>(instanceName: 'plainDio'),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(
        gh<_i74.AuthInterceptor>(),
        gh<_i824.TokenRefreshInterceptor>(),
      ),
    );
    gh.lazySingleton<_i180.AuthApi>(() => _i180.AuthApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i217.ProductApi>(() => _i217.ProductApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i610.ProductRepository>(
      () => _i652.ProductRepositoryImpl(gh<_i217.ProductApi>()),
    );
    gh.lazySingleton<_i245.AuthRepository>(
      () => _i694.AuthRepositoryImpl(
        gh<_i180.AuthApi>(),
        gh<_i363.TokenStorage>(),
        gh<_i159.AuthStatusSource>(),
      ),
    );
    gh.factory<_i430.GetProductUseCase>(
      () => _i430.GetProductUseCase(gh<_i610.ProductRepository>()),
    );
    gh.factory<_i586.GetProductsUseCase>(
      () => _i586.GetProductsUseCase(gh<_i610.ProductRepository>()),
    );
    gh.factory<_i760.LoginUseCase>(
      () => _i760.LoginUseCase(gh<_i245.AuthRepository>()),
    );
    gh.factory<_i362.LogoutUseCase>(
      () => _i362.LogoutUseCase(gh<_i245.AuthRepository>()),
    );
    gh.factory<_i701.WatchAuthStatusUseCase>(
      () => _i701.WatchAuthStatusUseCase(gh<_i245.AuthRepository>()),
    );
    gh.factory<_i33.ProductsBloc>(
      () => _i33.ProductsBloc(gh<_i586.GetProductsUseCase>()),
    );
    gh.lazySingleton<_i235.SessionBloc>(
      () => _i235.SessionBloc(
        gh<_i701.WatchAuthStatusUseCase>(),
        gh<_i362.LogoutUseCase>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.factoryParam<_i7.ProductDetailBloc, _i71.Product?, dynamic>(
      (preview, _) => _i7.ProductDetailBloc(
        gh<_i430.GetProductUseCase>(),
        preview: preview,
      ),
    );
    gh.factory<_i99.LoginBloc>(() => _i99.LoginBloc(gh<_i760.LoginUseCase>()));
    gh.lazySingleton<_i60.AppRouter>(
      () => _i60.AppRouter(gh<_i235.SessionBloc>()),
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}

class _$StorageModule extends _i918.StorageModule {}

class _$NetworkModule extends _i794.NetworkModule {}
