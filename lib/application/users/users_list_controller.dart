import 'package:flutter/foundation.dart';

import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/task/src/task_err.dart';
import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/entities/users_response.dart';
import 'package:random_user/domain/usecases/get_users.dart';

final class UsersListController extends ChangeNotifier {
  UsersListController(this._getUsers);

  static const int _initialPage = 1;
  static const int _initialPageSize = 50;
  static const int _nextPageSize = 20;

  final GetUsersUseCase _getUsers;

  final List<User> _items = [];
  AsyncValue<List<User>> users = const AsyncValue();
  AsyncValue<TaskErr>? loadMoreError;
  int _currentPage = 0;
  bool isLoadingMore = false;
  bool hasMore = true;

  List<User> get items => List.unmodifiable(_items);

  Future<void> loadInitial() async {
    users = users.toLoading();
    _currentPage = 0;
    _items.clear();
    hasMore = true;
    loadMoreError = null;
    notifyListeners();

    final result = await _getUsers(
      const GetUsersParams(page: _initialPage, results: _initialPageSize),
    );
    _applyResult(result, isInitial: true);
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore || users.status != Status.success) return;

    isLoadingMore = true;
    loadMoreError = null;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final result = await _getUsers(
      GetUsersParams(page: nextPage, results: _nextPageSize),
    );
    _applyResult(result, isInitial: false);
  }

  Future<void> retryLoadMore() async {
    loadMoreError = null;
    await loadMore();
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
        final pageSize = isInitial ? _initialPageSize : _nextPageSize;
        hasMore = response.users.isNotEmpty && response.users.length >= pageSize;
        users = users.toSuccess(List.unmodifiable(_items));
      },
      err: (err) {
        if (isInitial) {
          users = users.toError(err);
        } else {
          loadMoreError = loadMoreError == null
              ? const AsyncValue<TaskErr>().toError(err)
              : loadMoreError!.toError(err);
        }
      },
    );
    notifyListeners();
  }
}
