// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:dummy_shop/data/repositories/auth_repository_impl.dart'
    as _i694;
import 'package:dummy_shop/data/sources/local/auth_status_source.dart' as _i159;
import 'package:dummy_shop/data/sources/local/token_storage.dart' as _i363;
import 'package:dummy_shop/data/sources/remote/auth_api.dart' as _i180;
import 'package:dummy_shop/domain/repositories/auth_repository.dart' as _i245;
import 'package:dummy_shop/domain/use_cases/login_use_case.dart' as _i760;
import 'package:dummy_shop/domain/use_cases/logout_use_case.dart' as _i362;
import 'package:dummy_shop/domain/use_cases/watch_auth_status_use_case.dart'
    as _i701;
import 'package:dummy_shop/injection/modules/network_module.dart' as _i794;
import 'package:dummy_shop/injection/modules/storage_module.dart' as _i918;
import 'package:dummy_shop/presentation/app/router/app_router.dart' as _i60;
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
    final networkModule = _$NetworkModule();
    final storageModule = _$StorageModule();
    gh.singleton<_i60.AppRouter>(() => _i60.AppRouter());
    gh.lazySingleton<_i159.AuthStatusSource>(
      () => _i159.AuthStatusSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => storageModule.secureStorage,
    );
    gh.lazySingleton<_i363.TokenStorage>(
      () => _i363.TokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i180.AuthApi>(() => _i180.AuthApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i245.AuthRepository>(
      () => _i694.AuthRepositoryImpl(
        gh<_i180.AuthApi>(),
        gh<_i363.TokenStorage>(),
        gh<_i159.AuthStatusSource>(),
      ),
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
    return this;
  }
}

class _$NetworkModule extends _i794.NetworkModule {}

class _$StorageModule extends _i918.StorageModule {}
