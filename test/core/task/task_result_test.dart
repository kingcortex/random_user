import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/core/task/src/task_err.dart';
import 'package:random_user/core/task/src/task_result.dart';

void main() {
  group('TaskResult', () {
    test('ok factory produces a success', () {
      final r = TaskResult<String>.ok('hello');
      expect(r.isOk, true);
      expect(r.isErr, false);
      expect(r.ok, 'hello');
      expect(r.error, isNull);
    });

    test('err factory produces a failure', () {
      final r = TaskResult<String>.err(TaskErr.message('boom'));
      expect(r.isOk, false);
      expect(r.isErr, true);
      expect(r.ok, isNull);
      expect(r.error, isNotNull);
    });

    test('call() returns value when ok, null when err', () {
      expect(TaskResult<String>.ok('x')(), 'x');
      expect(TaskResult<String>.err(TaskErr.message('e'))(), isNull);
    });

    test('unwrap returns value when ok', () {
      expect(TaskResult<String>.ok('x').unwrap, 'x');
    });

    test('unwrap throws StateError when err', () {
      expect(
        () => TaskResult<String>.err(TaskErr.message('e')).unwrap,
        throwsStateError,
      );
    });

    test('okOr returns value when ok', () {
      expect(
        TaskResult<String>.ok('x').okOr(or: () => 'fallback'),
        'x',
      );
    });

    test('okOr returns fallback when err and or is provided', () {
      expect(
        TaskResult<String>.err(TaskErr.message('e')).okOr(or: () => 'fallback'),
        'fallback',
      );
    });

    test('okOr throws when err and no or', () {
      expect(
        () => TaskResult<String>.err(TaskErr.message('e')).okOr(),
        throwsStateError,
      );
    });

    test('on dispatches to ok callback on success', () {
      String? captured;
      TaskErr? capturedErr;
      TaskResult<String>.ok('x').on(
        ok: (v) => captured = v,
        err: (e) => capturedErr = e,
      );
      expect(captured, 'x');
      expect(capturedErr, isNull);
    });

    test('on dispatches to err callback on failure', () {
      String? captured;
      TaskErr? capturedErr;
      TaskResult<String>.err(TaskErr.message('e')).on(
        ok: (v) => captured = v,
        err: (e) => capturedErr = e,
      );
      expect(captured, isNull);
      expect(capturedErr, isNotNull);
    });

    test('map transforms value on success', () {
      final r = TaskResult<int>.ok(2).map((v) => v * 10);
      expect(r.isOk, true);
      expect(r.ok, 20);
    });

    test('map propagates error on failure', () {
      final r = TaskResult<int>.err(TaskErr.message('e')).map((v) => v * 10);
      expect(r.isErr, true);
      expect(r.ok, isNull);
    });
  });
}
