import 'package:flutter/foundation.dart';

import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/usecases/get_user_by_id.dart';

final class UserDetailsController extends ChangeNotifier {
  UserDetailsController(this._getUserById);

  final GetUserByIdUseCase _getUserById;

  AsyncValue<User> user = const AsyncValue();

  Future<void> load(String id) async {
    user = user.toLoading();
    notifyListeners();

    final result = await _getUserById(GetUserByIdParams(id: id));
    result.on(
      ok: (u) => user = AsyncValue(value: u, status: Status.success),
      err: (err) => user = AsyncValue(status: Status.error, message: err),
    );
    notifyListeners();
  }
}
