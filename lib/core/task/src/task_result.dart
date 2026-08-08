import 'package:flutter/foundation.dart';
import 'package:random_user/core/task/src/task_err.dart';

import 'task_process.dart';

external Future<TaskResult<Object>> processDyn(Future<Object> task);

final class TaskResult<T extends Object> {
  @internal
  const TaskResult({
    this.ok,
    this.error,
  }) : assert(ok != null || error != null, 'Either ok or error must be provided.');

  static Future<TaskResult<T>> process<T extends Object>(Future<T> task) {
    final processer = TaskProcess.processer;
    if (processer == null) {
      throw StateError('No TaskProcess implementation found. Please set TaskProcess.processer before calling process.');
    }
    return processer.process(task).then((result) {
      return result.map((data) => data as T);
    });
  }

  factory TaskResult.ok(T data) {
    return TaskResult(ok: data);
  }

  factory TaskResult.err(TaskErr error) {
    return TaskResult(error: error);
  }

  T? call() {
    return isOk ? ok : null;
  }

  final T? ok;
  final TaskErr? error;

  bool get isOk => ok != null && error == null;
  bool get isErr => error != null && ok == null;

  T get unwrap {
    if (isOk) {
      return ok!;
    } else {
      throw StateError('Cannot unwrap an error result: $error');
    }
  }

  T okOr({T Function()? or}) {
    if (isOk) {
      return ok!;
    } else if (or != null) {
      return or();
    } else {
      throw StateError('Cannot get ok value from an error result: $error');
    }
  }

  void on({
    required void Function(T data) ok,
    required void Function(TaskErr error) err,
  }) {
    if (isOk) {
      ok(unwrap);
    } else if (isErr) {
      err(error!);
    } else {
      throw StateError('ProcessingResult is neither ok nor error.');
    }
  }

  TaskResult<R> map<R extends Object>(R Function(T data) transform) {
    if (isOk) {
      return TaskResult.ok(transform(unwrap));
    } else {
      return TaskResult.err(error!);
    }
  }
}
