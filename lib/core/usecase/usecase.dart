import '../task/src/task_result.dart';

abstract interface class UseCase<T extends Object, Params> {
  Future<TaskResult<T>> call(Params params);
}

class NoParams {
  const NoParams();
}
