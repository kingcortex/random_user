import 'package:injectable/injectable.dart';

import 'package:random_user/domain/repositories/user_repository.dart';
import 'package:random_user/domain/usecases/get_user_by_id.dart';
import 'package:random_user/domain/usecases/get_users.dart';

@module
abstract class DiUseCasesModule {
  @lazySingleton
  GetUsersUseCase provideGetUsers(UserRepository repository) =>
      GetUsersUseCase(repository);

  @lazySingleton
  GetUserByIdUseCase provideGetUserById(UserRepository repository) =>
      GetUserByIdUseCase(repository);
}
