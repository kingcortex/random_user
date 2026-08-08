import 'package:injectable/injectable.dart';

import 'package:random_user/domain/repositories/user_repository.dart';
import 'package:random_user/infrastructure/datasources/local/user_local_datasource.dart';
import 'package:random_user/infrastructure/datasources/remote/user_remote_datasource.dart';
import 'package:random_user/infrastructure/repositories/user_repository_impl.dart';

@module
abstract class DiRepositoriesModule {
  @lazySingleton
  UserRepository provideUserRepository(
    UserRemoteDataSource remote,
    UserLocalDataSource local,
  ) =>
      UserRepositoryImpl(remote: remote, local: local);
}
