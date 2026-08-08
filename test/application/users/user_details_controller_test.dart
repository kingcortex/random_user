import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/application/users/user_details_controller.dart';
import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/task/src/task_err.dart';
import 'package:random_user/core/task/src/task_result.dart';
import 'package:random_user/domain/entities/location.dart';
import 'package:random_user/domain/entities/name.dart';
import 'package:random_user/domain/entities/picture.dart';
import 'package:random_user/domain/entities/street.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/domain/repositories/user_repository.dart';
import 'package:random_user/domain/usecases/get_user_by_id.dart';

class FakeGetUserByIdUseCase implements GetUserByIdUseCase {
  TaskResult<User>? nextResult;
  int callCount = 0;
  GetUserByIdParams? lastParams;

  @override
  UserRepository get repository => throw UnimplementedError('not used in test');

  @override
  Future<TaskResult<User>> call(GetUserByIdParams params) async {
    callCount++;
    lastParams = params;
    if (nextResult == null) {
      throw StateError('FakeGetUserByIdUseCase: no nextResult set');
    }
    return nextResult!;
  }
}

User _user(String id) => User(
      id: id,
      gender: 'female',
      name: Name(title: 'Ms', first: 'Jane', last: 'Doe'),
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

void main() {
  late FakeGetUserByIdUseCase useCase;
  late UserDetailsController controller;

  setUp(() {
    useCase = FakeGetUserByIdUseCase();
    controller = UserDetailsController(useCase);
  });

  test('initial state is initial', () {
    expect(controller.user.status, Status.initial);
  });

  test('load success: status=success, value is the user', () async {
    useCase.nextResult = TaskResult.ok(_user('u1'));

    await controller.load('u1');

    expect(controller.user.status, Status.success);
    expect(controller.user.value, isNotNull);
    expect(controller.user.value!.id, 'u1');
    expect(controller.user.value!.email, 'u1@example.com');
    expect(useCase.callCount, 1);
    expect(useCase.lastParams!.id, 'u1');
  });

  test('load error: status=error, value preserved (toError keeps value)', () async {
    useCase.nextResult = TaskResult.err(TaskErr.message('boom'));

    await controller.load('missing');

    expect(controller.user.status, Status.error);
    expect(controller.user.message.displayMessage, 'boom');
  });

  test('load flips through loading then success', () async {
    useCase.nextResult = TaskResult.ok(_user('u1'));

    final future = controller.load('u1');
    expect(controller.user.status, Status.loading);
    await future;
    expect(controller.user.status, Status.success);
  });
}
