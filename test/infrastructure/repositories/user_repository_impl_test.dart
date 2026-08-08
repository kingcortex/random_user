import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/core/network/exceptions.dart';
import 'package:random_user/core/task/src/task_err.dart';
import 'package:random_user/infrastructure/datasources/local/user_local_datasource.dart';
import 'package:random_user/infrastructure/datasources/remote/user_remote_datasource.dart';
import 'package:random_user/infrastructure/models/location_model.dart';
import 'package:random_user/infrastructure/models/name_model.dart';
import 'package:random_user/infrastructure/models/page_info_model.dart';
import 'package:random_user/infrastructure/models/picture_model.dart';
import 'package:random_user/infrastructure/models/street_model.dart';
import 'package:random_user/infrastructure/models/user_model.dart';
import 'package:random_user/infrastructure/models/users_response_model.dart';
import 'package:random_user/infrastructure/repositories/user_repository_impl.dart';

class FakeRemoteDataSource implements UserRemoteDataSource {
  UsersResponseModel? nextResponse;
  NetworkException? nextError;
  int fetchPageCalls = 0;
  int? lastPage;
  int? lastResults;

  @override
  Future<UsersResponseModel> fetchPage({
    required int page,
    required int results,
  }) async {
    fetchPageCalls++;
    lastPage = page;
    lastResults = results;
    if (nextError != null) throw nextError!;
    if (nextResponse == null) {
      throw StateError('FakeRemoteDataSource: no response or error set');
    }
    return nextResponse!;
  }
}

class FakeLocalDataSource implements UserLocalDataSource {
  final Map<String, UserModel> stored = {};
  UserModel? nextGetResult;
  bool throwOnSave = false;
  int saveCalls = 0;
  int getCalls = 0;

  @override
  Future<void> saveUser(UserModel user) async {
    saveCalls++;
    if (throwOnSave) throw Exception('storage full');
    stored[user.id] = user;
  }

  @override
  Future<UserModel?> getUser(String id) async {
    getCalls++;
    return nextGetResult ?? stored[id];
  }

  @override
  Future<void> clear() async => stored.clear();
}

UserModel _user(String id) => UserModel(
      id: id,
      gender: 'male',
      name: const NameModel(title: 'Mr', first: 'A', last: 'B'),
      location: LocationModel(
        street: const StreetModel(number: 1, name: 'St'),
        city: 'City',
        state: 'State',
        country: 'Country',
        postcode: '00000',
      ),
      email: '$id@example.com',
      phone: '010-0000',
      cell: '010-0001',
      picture: const PictureModel(large: 'l', medium: 'm', thumbnail: 't'),
      nat: 'XX',
    );

UsersResponseModel _response(List<UserModel> users, {int page = 1, int results = 20}) =>
    UsersResponseModel(
      users: users,
      info: PageInfoModel(seed: 's', results: results, page: page, version: '1.4'),
    );

void main() {
  late FakeRemoteDataSource remote;
  late FakeLocalDataSource local;
  late UserRepositoryImpl repo;

  setUp(() {
    remote = FakeRemoteDataSource();
    local = FakeLocalDataSource();
    repo = UserRepositoryImpl(remote: remote, local: local);
  });

  group('fetchPage', () {
    test('success: returns UsersResponse, writes through to local', () async {
      remote.nextResponse = _response([_user('u1'), _user('u2')]);

      final result = await repo.fetchPage(page: 1, results: 20);

      expect(result.isOk, true);
      expect(result.ok!.users, hasLength(2));
      expect(result.ok!.users[0].id, 'u1');
      expect(result.ok!.info.page, 1);
      expect(remote.fetchPageCalls, 1);
      expect(remote.lastPage, 1);
      expect(remote.lastResults, 20);
      expect(local.saveCalls, 2);
      expect(local.stored.keys, containsAll(['u1', 'u2']));
    });

    test('NetworkException: returns TaskResult.err mapped from exception', () async {
      remote.nextError = TransportException.noConnection('offline');

      final result = await repo.fetchPage(page: 1, results: 20);

      expect(result.isErr, true);
      expect(result.error!.code, TaskErr.connectivityIssueCode);
      expect(local.saveCalls, 0);
    });

    test('local save failure: best-effort, still returns ok', () async {
      remote.nextResponse = _response([_user('u1')]);
      local.throwOnSave = true;

      final result = await repo.fetchPage(page: 1, results: 20);

      expect(result.isOk, true);
      expect(result.ok!.users, hasLength(1));
    });

    test('unmapped exception: returns TaskResult.err with message', () async {
      remote.nextError = const NetworkException('weird');

      final result = await repo.fetchPage(page: 1, results: 20);

      expect(result.isErr, true);
      expect(result.error!.message, 'weird');
    });
  });

  group('findById', () {
    test('hit: returns User entity from local', () async {
      local.nextGetResult = _user('u1');

      final result = await repo.findById('u1');

      expect(result.isOk, true);
      expect(result.ok!.id, 'u1');
      expect(result.ok!.email, 'u1@example.com');
    });

    test('miss: returns TaskResult.err with 404', () async {
      final result = await repo.findById('missing');

      expect(result.isErr, true);
      expect(result.error!.code, HttpStatus.notFound);
      expect(result.error!.message, 'User not found');
    });
  });
}
