import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/entities/users_response.dart';

abstract class UserRepository {
  Future<TaskResult<UsersResponse>> fetchPage({
    required int page,
    required int results,
  });

  Future<TaskResult<User>> findById(String id);
}
