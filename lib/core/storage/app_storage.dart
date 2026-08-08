import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferencesStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, {required bool value});
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

class AppPreferencesStorageImpl implements AppPreferencesStorage {
  AppPreferencesStorageImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;
  final SharedPreferences _sharedPreferences;

  @override
  Future<void> setString(String key, String value) async {
    final success = await _sharedPreferences.setString(key, value);
    if (!success) {
      throw Exception('Failed to save string preference for key: $key');
    }
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> setBool(String key, {required bool value}) async {
    final success = await _sharedPreferences.setBool(key, value);
    if (!success) {
      throw Exception('Failed to save boolean preference for key: $key');
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    final success = await _sharedPreferences.setInt(key, value);
    if (!success) {
      throw Exception('Failed to save integer preference for key: $key');
    }
  }

  @override
  Future<int?> getInt(String key) async {
    return _sharedPreferences.getInt(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    final success = await _sharedPreferences.setDouble(key, value);
    if (!success) {
      throw Exception('Failed to save double preference for key: $key');
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    return _sharedPreferences.getDouble(key);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    final success = await _sharedPreferences.setStringList(key, value);
    if (!success) {
      throw Exception('Failed to save string list preference for key: $key');
    }
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _sharedPreferences.getStringList(key);
  }

  @override
  Future<void> remove(String key) async {
    final success = await _sharedPreferences.remove(key);
    if (!success) {
      throw Exception('Failed to remove preference for key: $key');
    }
  }

  @override
  Future<void> clear() async {
    final success = await _sharedPreferences.clear();
    if (!success) {
      throw Exception('Failed to clear all preferences');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    return _sharedPreferences.containsKey(key);
  }
}
