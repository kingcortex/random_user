typedef JsonMap = Map<String, dynamic>;

T dynParser<T extends Object>(dynamic value, {T? or}) {
  return switch (T) {
    const (String) => _toString(value) as T,
    const (bool) => _toBool(value) as T,
    const (num) => _toNum(value) as T,
    const (int) => _toInt(value) as T,
    const (double) => _toDouble(value) as T,
    const (List<String>) => _toList<String>(value) as T,
    const (List<bool>) => _toList<bool>(value) as T,
    const (List<num>) => _toList<num>(value) as T,
    const (List<int>) => _toList<int>(value) as T,
    const (List<double>) => _toList<double>(value) as T,
    const (List<JsonMap>) => _toList<JsonMap>(value) as T,
    const (List) => _toDynList(value) as T,
    const (Map<String, dynamic>) => _toDynMap(value) as T,
    const (Map) => _toDynMap(value) as T,
    const (Map<String, String>) => _toDynMap(value).map((k, v) => MapEntry(k, _toString(v))) as T,
    const (Map<String, bool>) => _toDynMap(value).map((k, v) => MapEntry(k, _toBool(v))) as T,
    const (Map<String, num>) => _toDynMap(value).map((k, v) => MapEntry(k, _toNum(v))) as T,
    const (Map<String, int>) => _toDynMap(value).map((k, v) => MapEntry(k, _toInt(v))) as T,
    const (Map<String, double>) => _toDynMap(value).map((k, v) => MapEntry(k, _toDouble(v))) as T,
    _ when or != null => or,
    _ => throw Exception('Unsupported type for dynamic parsing: $T'),
  };
}

String _toString(dynamic value) {
  if (value == null) {
    return '';
  }
  return value.toString();
}

bool _toBool(dynamic value) {
  if (value == null) {
    return false;
  }
  if (value is bool) {
    return value;
  }
  return bool.tryParse(_toString(value)) ?? false;
}

num _toNum(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is num) {
    return value;
  }
  final parsed = num.tryParse(_toString(value));
  return parsed ?? 0;
}

int _toInt(dynamic value) {
  return _toNum(value).toInt();
}

double _toDouble(dynamic value) {
  return _toNum(value).toDouble();
}

List<dynamic> _toDynList(dynamic value) {
  if (value is List) {
    return value;
  }

  if (value is Set) {
    return value.toList();
  }
  return [];
}

List<T> _toList<T extends Object>(dynamic value) {
  final list = _toDynList(value);
  return list.map((e) => dynParser<T>(e)).toList();
}

Map<String, dynamic> _toDynMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return {};
}
