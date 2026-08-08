import 'package:random_user/core/network/exceptions.dart';
import 'package:random_user/core/task/src/task_err.dart';

TaskErr mapNetworkException(NetworkException e) {
  final code = e is TransportException
      ? TaskErr.connectivityIssueCode
      : e.code;
  return TaskErr(
    message: e.message,
    code: code,
    type: e.runtimeType.toString(),
  );
}
