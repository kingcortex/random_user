import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/core/usecase/usecase.dart';
import 'package:random_user/domain/entities/users_response.dart';
import 'package:random_user/domain/repositories/user_repository.dart';

final class GetUsersParams {
  const GetUsersParams({required this.page, required this.results});

  final int page;
  final int results;
}

final class GetUsersUseCase implements UseCase<UsersResponse, GetUsersParams> {
  const GetUsersUseCase(this.repository);

  final UserRepository repository;

  @override
  Future<TaskResult<UsersResponse>> call(GetUsersParams params) {
    return repository.fetchPage(page: params.page, results: params.results);
  }
}
