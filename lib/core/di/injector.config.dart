// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../application/users/user_details_controller.dart' as _i29;
import '../../application/users/users_list_controller.dart' as _i148;
import '../../domain/repositories/user_repository.dart' as _i271;
import '../../domain/usecases/get_user_by_id.dart' as _i103;
import '../../domain/usecases/get_users.dart' as _i915;
import '../../infrastructure/datasources/local/user_local_datasource.dart'
    as _i160;
import '../../infrastructure/datasources/remote/user_remote_datasource.dart'
    as _i16;
import '../network/client.dart' as _i99;
import '../storage/app_storage.dart' as _i66;
import 'di_application.dart' as _i51;
import 'di_core.dart' as _i875;
import 'di_datasources.dart' as _i469;
import 'di_external.dart' as _i267;
import 'di_repositories.dart' as _i612;
import 'di_usecases.dart' as _i489;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final diExternal = _$DiExternal();
    final diCoreModule = _$DiCoreModule();
    final diDataSourcesModule = _$DiDataSourcesModule();
    final diRepositoriesModule = _$DiRepositoriesModule();
    final diUseCasesModule = _$DiUseCasesModule();
    final diApplicationModule = _$DiApplicationModule();
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => diExternal.provideSharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => diExternal.provideDio());
    gh.lazySingleton<_i99.HttpClient>(
      () => diCoreModule.provideHttpClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i16.UserRemoteDataSource>(
      () => diDataSourcesModule.provideRemoteDataSource(gh<_i99.HttpClient>()),
    );
    gh.lazySingleton<_i66.AppPreferencesStorage>(
      () => diCoreModule.provideAppPreferencesStorage(
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i160.UserLocalDataSource>(
      () => diDataSourcesModule.provideLocalDataSource(
        gh<_i66.AppPreferencesStorage>(),
      ),
    );
    gh.lazySingleton<_i271.UserRepository>(
      () => diRepositoriesModule.provideUserRepository(
        gh<_i16.UserRemoteDataSource>(),
        gh<_i160.UserLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i915.GetUsersUseCase>(
      () => diUseCasesModule.provideGetUsers(gh<_i271.UserRepository>()),
    );
    gh.lazySingleton<_i103.GetUserByIdUseCase>(
      () => diUseCasesModule.provideGetUserById(gh<_i271.UserRepository>()),
    );
    gh.factory<_i29.UserDetailsController>(
      () => diApplicationModule.provideUserDetailsController(
        gh<_i103.GetUserByIdUseCase>(),
      ),
    );
    gh.factory<_i148.UsersListController>(
      () => diApplicationModule.provideUsersListController(
        gh<_i915.GetUsersUseCase>(),
      ),
    );
    return this;
  }
}

class _$DiExternal extends _i267.DiExternal {}

class _$DiCoreModule extends _i875.DiCoreModule {}

class _$DiDataSourcesModule extends _i469.DiDataSourcesModule {}

class _$DiRepositoriesModule extends _i612.DiRepositoriesModule {}

class _$DiUseCasesModule extends _i489.DiUseCasesModule {}

class _$DiApplicationModule extends _i51.DiApplicationModule {}
