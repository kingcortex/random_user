import 'package:injectable/injectable.dart';

import 'package:random_user/core/network/client.dart';
import 'package:random_user/core/storage/app_storage.dart';
import 'package:random_user/infrastructure/datasources/local/user_local_datasource.dart';
import 'package:random_user/infrastructure/datasources/local/user_local_datasource_impl.dart';
import 'package:random_user/infrastructure/datasources/remote/user_remote_datasource.dart';
import 'package:random_user/infrastructure/datasources/remote/user_remote_datasource_impl.dart';

@module
abstract class DiDataSourcesModule {
  @lazySingleton
  UserRemoteDataSource provideRemoteDataSource(HttpClient client) =>
      UserRemoteDataSourceImpl(client: client);

  @lazySingleton
  UserLocalDataSource provideLocalDataSource(AppPreferencesStorage storage) =>
      UserLocalDataSourceImpl(storage: storage);
}
