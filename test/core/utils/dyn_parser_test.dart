import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/core/utils/dyn_parser.dart';

void main() {
  group('dynParser', () {
    test('String from valid value', () {
      expect(dynParser<String>('hello'), 'hello');
      expect(dynParser<String>(''), '');
    });

    test('String from null returns empty', () {
      expect(dynParser<String>(null), '');
    });

    test('String from non-string converts via toString', () {
      expect(dynParser<String>(42), '42');
    });

    test('int from int value', () {
      expect(dynParser<int>(42), 42);
    });

    test('int from null returns 0', () {
      expect(dynParser<int>(null), 0);
    });

    test('int from string parses', () {
      expect(dynParser<int>('42'), 42);
      expect(dynParser<int>('not a number'), 0);
    });

    test('bool from true/false', () {
      expect(dynParser<bool>(true), true);
      expect(dynParser<bool>(false), false);
    });

    test('bool from string parses', () {
      expect(dynParser<bool>('true'), true);
      expect(dynParser<bool>('false'), false);
    });

    test('bool from null returns false', () {
      expect(dynParser<bool>(null), false);
    });

    test('double from num', () {
      expect(dynParser<double>(3.14), 3.14);
    });

    test('List<String> from list', () {
      expect(dynParser<List<String>>(['a', 'b']), ['a', 'b']);
    });

    test('List<String> from null returns empty', () {
      expect(dynParser<List<String>>(null), isEmpty);
    });

    test('List<String> coerces non-string elements', () {
      expect(dynParser<List<String>>([1, 2, 3]), ['1', '2', '3']);
    });

    test('List<JsonMap> from list of maps', () {
      final result = dynParser<List<JsonMap>>([{'a': 1}, {'b': 2}]);
      expect(result, hasLength(2));
      expect(result[0]['a'], 1);
    });

    test('JsonMap from map', () {
      final result = dynParser<JsonMap>({'key': 'value'});
      expect(result['key'], 'value');
    });

    test('JsonMap from null returns empty map', () {
      expect(dynParser<JsonMap>(null), isEmpty);
    });

    test('JsonMap from non-typed map coerces', () {
      final raw = <String, Object?>{'k': 'v'};
      expect(dynParser<JsonMap>(raw), {'k': 'v'});
    });

    test('falls back to "or" when type is unsupported', () {
      const unsupported = _UnsupportedType();
      expect(dynParser<_UnsupportedType>(null, or: unsupported), unsupported);
    });
  });
}

class _UnsupportedType {
  const _UnsupportedType();
}
