import 'package:random_user/core/network/exceptions.dart';
import 'package:random_user/core/task/src/task_err.dart';
import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/entities/users_response.dart';
import 'package:random_user/domain/repositories/user_repository.dart';
import 'package:random_user/infrastructure/datasources/local/user_local_datasource.dart';
import 'package:random_user/infrastructure/datasources/remote/user_remote_datasource.dart';
import 'package:random_user/infrastructure/errors/network_failure_mapper.dart';

final class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({required this.remote, required this.local});

  final UserRemoteDataSource remote;
  final UserLocalDataSource local;

  @override
  Future<TaskResult<UsersResponse>> fetchPage({
    required int page,
    required int results,
  }) async {
    try {
      final response = await remote.fetchPage(page: page, results: results);

      for (final user in response.users) {
        try {
          await local.saveUser(user);
        } catch (_) {}
      }

      return TaskResult.ok(response.toEntity());
    } on NetworkException catch (e) {
      return TaskResult.err(mapNetworkException(e));
    } catch (e) {
      return TaskResult.err(TaskErr.message(e.toString()));
    }
  }

  @override
  Future<TaskResult<User>> findById(String id) async {
    try {
      final model = await local.getUser(id);
      if (model == null) {
        return TaskResult.err(
          TaskErr.message('Utilisateur introuvable', code: 404),
        );
      }
      return TaskResult.ok(model.toEntity());
    } catch (e) {
      return TaskResult.err(TaskErr.message(e.toString()));
    }
  }
}
