import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/task/src/task_err.dart';

void main() {
  group('AsyncValue', () {
    test('default ctor produces initial state', () {
      const v = AsyncValue<String>();
      expect(v.isInitial, true);
      expect(v.isLoading, false);
      expect(v.isSuccess, false);
      expect(v.isError, false);
      expect(v.value, isNull);
    });

    test('toLoading flips to loading and keeps current value', () {
      const v = AsyncValue<String>(value: 'kept');
      final loaded = v.toLoading();
      expect(loaded.isLoading, true);
      expect(loaded.value, 'kept');
    });

    test('toSuccess replaces value and flips to success', () {
      const v = AsyncValue<String>();
      final ok = v.toSuccess('hello');
      expect(ok.isSuccess, true);
      expect(ok.value, 'hello');
    });

    test('toError flips to error, keeps current value', () {
      const v = AsyncValue<String>(value: 'kept');
      final err = v.toError(TaskErr.message('boom'));
      expect(err.isError, true);
      expect(err.value, 'kept');
      expect(err.message.displayMessage, 'boom');
    });

    test('toInitial resets state', () {
      const v = AsyncValue<String>(value: 'x', status: Status.success);
      final init = v.toInitial();
      expect(init.isInitial, true);
      expect(init.value, isNull);
    });

    test('changeValue replaces value, keeps status and message', () {
      const v = AsyncValue<String>(status: Status.success);
      final changed = v.changeValue('new');
      expect(changed.value, 'new');
      expect(changed.isSuccess, true);
    });

    test('map transforms value, keeps status and message', () {
      const v = AsyncValue<int>(value: 5, status: Status.success);
      final mapped = v.map((v) => 'count=$v');
      expect(mapped.value, 'count=5');
      expect(mapped.isSuccess, true);
    });

    test('map on null value returns null', () {
      const v = AsyncValue<int>();
      final mapped = v.map((v) => v * 2);
      expect(mapped.value, isNull);
    });

    test('unwrap throws when value is null', () {
      expect(() => const AsyncValue<int>().unwrap(), throwsStateError);
    });

    test('unwrapOr returns value when present, default when null', () {
      const v = AsyncValue<int>(value: 42);
      const v2 = AsyncValue<int>();
      expect(v.unwrapOr(0), 42);
      expect(v2.unwrapOr(99), 99);
    });

    test('props equality', () {
      const a = AsyncValue<String>(value: 'x', status: Status.success);
      const b = AsyncValue<String>(value: 'x', status: Status.success);
      expect(a, b);
    });
  });
}
