import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/core/network/exceptions.dart';
import 'package:random_user/core/task/src/task_err.dart';
import 'package:random_user/infrastructure/errors/network_failure_mapper.dart';

void main() {
  group('mapNetworkException', () {
    test('TransportException → connectivityIssueCode', () {
      final e = TransportException.noConnection('boom');
      final mapped = mapNetworkException(e);
      expect(mapped.code, TaskErr.connectivityIssueCode);
      expect(mapped.message, 'boom');
    });

    test('UnauthorizedException → keeps HTTP code', () {
      final e = UnauthorizedException(code: 401, message: 'nope');
      final mapped = mapNetworkException(e);
      expect(mapped.code, 401);
      expect(mapped.message, 'nope');
    });

    test('NotFoundException → code 404', () {
      const e = NotFoundException();
      final mapped = mapNetworkException(e);
      expect(mapped.code, 404);
    });

    test('ValidationException → keeps HTTP code', () {
      const e = ValidationException(code: 422, message: 'invalid');
      final mapped = mapNetworkException(e);
      expect(mapped.code, 422);
      expect(mapped.message, 'invalid');
    });

    test('ServerException → keeps HTTP code', () {
      const e = ServerException(code: 500);
      final mapped = mapNetworkException(e);
      expect(mapped.code, 500);
    });

    test('UnknownNetworkException → null code', () {
      const e = UnknownNetworkException();
      final mapped = mapNetworkException(e);
      expect(mapped.code, isNull);
    });
  });
}
