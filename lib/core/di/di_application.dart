import 'package:injectable/injectable.dart';

import 'package:random_user/application/users/user_details_controller.dart';
import 'package:random_user/application/users/users_list_controller.dart';
import 'package:random_user/domain/usecases/get_user_by_id.dart';
import 'package:random_user/domain/usecases/get_users.dart';

@module
abstract class DiApplicationModule {
  @injectable
  UsersListController provideUsersListController(GetUsersUseCase getUsers) =>
      UsersListController(getUsers);

  @injectable
  UserDetailsController provideUserDetailsController(
    GetUserByIdUseCase getUserById,
  ) => UserDetailsController(getUserById);
}
