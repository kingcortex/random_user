import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/core/usecase/usecase.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/repositories/user_repository.dart';

final class GetUserByIdParams {
  const GetUserByIdParams({required this.id});

  final String id;
}

class GetUserByIdUseCase implements UseCase<User, GetUserByIdParams> {
  const GetUserByIdUseCase(this.repository);

  final UserRepository repository;

  @override
  Future<TaskResult<User>> call(GetUserByIdParams params) {
    return repository.findById(params.id);
  }
}
