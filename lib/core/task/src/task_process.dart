import 'package:random_user/core/task/src/task_result.dart';


abstract interface class TaskProcess {
  Future<TaskResult<Object>> process(Future<Object> task);

  static TaskProcess? processer;
}
