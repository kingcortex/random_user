import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/application/users/users_list_controller.dart';
import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/task/src/task_err.dart';
import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/domain/entities/location.dart';
import 'package:random_user/domain/entities/name.dart';
import 'package:random_user/domain/entities/page_info.dart';
import 'package:random_user/domain/entities/picture.dart';
import 'package:random_user/domain/entities/street.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/entities/users_response.dart';
import 'package:random_user/domain/repositories/user_repository.dart';
import 'package:random_user/domain/usecases/get_users.dart';

class FakeGetUsersUseCase implements GetUsersUseCase {
  TaskResult<UsersResponse>? nextResult;
  int callCount = 0;
  GetUsersParams? lastParams;

  @override
  UserRepository get repository => throw UnimplementedError('not used in test');

  @override
  Future<TaskResult<UsersResponse>> call(GetUsersParams params) async {
    callCount++;
    lastParams = params;
    if (nextResult == null) {
      throw StateError('FakeGetUsersUseCase: no nextResult set');
    }
    return nextResult!;
  }
}

User _user(String id) => User(
      id: id,
      gender: 'male',
      name: Name(title: 'Mr', first: 'A', last: 'B'),
      location: Location(
        street: Street(number: 1, name: 'St'),
        city: 'City',
        state: 'State',
        country: 'Country',
        postcode: '00000',
      ),
      email: '$id@example.com',
      phone: '010-0000',
      cell: '010-0001',
      picture: Picture(large: 'l', medium: 'm', thumbnail: 't'),
      nat: 'XX',
    );

UsersResponse _response(List<User> users, {int page = 1, int results = 20}) =>
    UsersResponse(
      users: users,
      info: PageInfo(seed: 's', results: results, page: page, version: '1.4'),
    );

void main() {
  late FakeGetUsersUseCase useCase;
  late UsersListController controller;

  setUp(() {
    useCase = FakeGetUsersUseCase();
    controller = UsersListController(useCase);
  });

  group('loadInitial', () {
    test('success: populates items, status=success, hasMore=true', () async {
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(50, (i) => _user('u$i')), page: 1, results: 50),
      );

      await controller.loadInitial();

      expect(controller.items, hasLength(50));
      expect(controller.users.status, Status.success);
      expect(controller.hasMore, true);
      expect(useCase.callCount, 1);
      expect(useCase.lastParams!.page, 1);
      expect(useCase.lastParams!.results, 50);
    });

    test('success: smaller page sets hasMore=false', () async {
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(10, (i) => _user('u$i')), page: 1, results: 50),
      );

      await controller.loadInitial();

      expect(controller.hasMore, false);
    });

    test('error: sets status=error, hasMore=true (default)', () async {
      useCase.nextResult = TaskResult.err(TaskErr.message('boom'));

      await controller.loadInitial();

      expect(controller.users.status, Status.error);
      expect(controller.users.message.displayMessage, 'boom');
      expect(controller.hasMore, true);
      expect(controller.items, isEmpty);
    });

    test('NetworkException: maps to connectivity code', () async {
      useCase.nextResult = TaskResult.err(
        const TaskErr(code: TaskErr.connectivityIssueCode, message: 'offline'),
      );

      await controller.loadInitial();

      expect(controller.users.status, Status.error);
      expect(controller.users.message.code, TaskErr.connectivityIssueCode);
    });
  });

  group('loadMore', () {
    setUp(() async {
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(50, (i) => _user('init$i')), page: 1, results: 50),
      );
      await controller.loadInitial();
    });

    test('success: appends items, sets isLoadingMore=false', () async {
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(20, (i) => _user('more$i')), page: 2, results: 20),
      );

      await controller.loadMore();

      expect(controller.items, hasLength(70));
      expect(controller.isLoadingMore, false);
      expect(controller.users.status, Status.success);
      expect(useCase.lastParams!.page, 2);
      expect(useCase.lastParams!.results, 20);
    });

    test('no-op when isLoadingMore', () async {
      useCase.callCount = 0;
      controller.isLoadingMore = true;
      await controller.loadMore();
      expect(useCase.callCount, 0);
    });

    test('no-op when hasMore=false', () async {
      useCase.callCount = 0;
      controller.hasMore = false;
      await controller.loadMore();
      expect(useCase.callCount, 0);
    });

    test('no-op when users.status != success', () async {
      useCase.callCount = 0;
      controller.users = controller.users.toError(TaskErr.message('e'));
      await controller.loadMore();
      expect(useCase.callCount, 0);
    });

    test('error: sets loadMoreError, status stays success', () async {
      useCase.nextResult = TaskResult.err(TaskErr.message('next fail'));

      await controller.loadMore();

      expect(controller.loadMoreError, isNotNull);
      expect(controller.loadMoreError!.status, Status.error);
      expect(controller.loadMoreError!.message.displayMessage, 'next fail');
      expect(controller.users.status, Status.success);
      expect(controller.isLoadingMore, false);
    });

    test('error: incomplete page sets hasMore=false', () async {
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(5, (i) => _user('more$i')), page: 2, results: 20),
      );

      await controller.loadMore();

      expect(controller.hasMore, false);
    });
  });

  group('retryLoadMore', () {
    setUp(() async {
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(50, (i) => _user('init$i')), page: 1, results: 50),
      );
      await controller.loadInitial();
    });

    test('clears loadMoreError then calls loadMore', () async {
      controller.loadMoreError = const AsyncValue<TaskErr>().toError(
        TaskErr.message('previous fail'),
      );
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(20, (i) => _user('retry$i')), page: 2, results: 20),
      );
      final callsBefore = useCase.callCount;

      await controller.retryLoadMore();

      expect(controller.loadMoreError, isNull);
      expect(controller.items, hasLength(70));
      expect(useCase.callCount, callsBefore + 1);
    });
  });

  group('refresh', () {
    test('resets state then loads', () async {
      useCase.nextResult = TaskResult.ok(
        _response(List.generate(50, (i) => _user('first$i')), page: 1, results: 50),
      );
      await controller.loadInitial();
      expect(controller.items, hasLength(50));

      useCase.nextResult = TaskResult.ok(
        _response(List.generate(30, (i) => _user('refresh$i')), page: 1, results: 50),
      );
      await controller.refresh();

      expect(controller.items, hasLength(30));
      expect(controller.items.first.id, 'refresh0');
    });
  });
}
