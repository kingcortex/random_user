import 'package:flutter/foundation.dart';

import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/entities/users_response.dart';
import 'package:random_user/domain/usecases/get_users.dart';

final class UsersListController extends ChangeNotifier {
  UsersListController(this._getUsers);

  static const int _initialPageSize = 50;
  static const int _nextPageSize = 20;

  final GetUsersUseCase _getUsers;

  final List<User> _items = [];
  AsyncValue<List<User>> users = const AsyncValue();
  int _currentPage = 0;
  bool isLoadingMore = false;
  bool hasMore = true;

  List<User> get items => List.unmodifiable(_items);

  Future<void> loadInitial() async {
    users = users.toLoading();
    _currentPage = 0;
    _items.clear();
    hasMore = true;
    notifyListeners();

    final result = await _getUsers(
      const GetUsersParams(page: 1, results: _initialPageSize),
    );
    _applyResult(result, isInitial: true);
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore || users.status != Status.success) return;

    isLoadingMore = true;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final result = await _getUsers(
      GetUsersParams(page: nextPage, results: _nextPageSize),
    );
    _applyResult(result, isInitial: false);
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  void _applyResult(TaskResult<UsersResponse> result, {required bool isInitial}) {
    isLoadingMore = false;
    result.on(
      ok: (response) {
        _items.addAll(response.users);
        _currentPage = response.info.page;
        hasMore = response.users.length >= (isInitial ? _initialPageSize : _nextPageSize);
        users = AsyncValue(
          value: List.unmodifiable(_items),
          status: Status.success,
        );
      },
      err: (err) {
        if (isInitial) {
          users = AsyncValue(status: Status.error, message: err);
        }
      },
    );
    notifyListeners();
  }
}
