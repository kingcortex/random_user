import 'dart:convert';

import 'package:random_user/core/storage/app_storage.dart';
import 'package:random_user/core/storage/cache_keys.dart';
import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/infrastructure/datasources/local/user_local_datasource.dart';
import 'package:random_user/infrastructure/models/user_model.dart';

final class UserLocalDataSourceImpl implements UserLocalDataSource {
  const UserLocalDataSourceImpl({required this.storage});

  static const Duration kCacheDuration = Duration(hours: 24);

  final AppPreferencesStorage storage;

  @override
  Future<void> saveUser(UserModel user) async {
    final users = await _loadUsers();
    users[user.id] = user.toJson();
    await storage.setString(CacheKeys.userCache, jsonEncode(users));

    final timestamps = await _loadTimestamps();
    timestamps[user.id] = DateTime.now().millisecondsSinceEpoch;
    await storage.setString(CacheKeys.userCacheTimestamps, jsonEncode(timestamps));
  }

  @override
  Future<UserModel?> getUser(String id) async {
    final timestamps = await _loadTimestamps();
    final savedAt = timestamps[id];
    if (savedAt == null) return null;

    final age = DateTime.now().millisecondsSinceEpoch - savedAt;
    if (age > kCacheDuration.inMilliseconds) {
      await _removeEntry(id);
      return null;
    }

    final users = await _loadUsers();
    final json = users[id];
    if (json == null) return null;
    return UserModel.fromJson(dynParser<JsonMap>(json));
  }

  @override
  Future<void> clear() async {
    await storage.remove(CacheKeys.userCache);
    await storage.remove(CacheKeys.userCacheTimestamps);
  }

  Future<void> _removeEntry(String id) async {
    final users = await _loadUsers();
    users.remove(id);
    await storage.setString(CacheKeys.userCache, jsonEncode(users));

    final timestamps = await _loadTimestamps();
    timestamps.remove(id);
    await storage.setString(CacheKeys.userCacheTimestamps, jsonEncode(timestamps));
  }

  Future<Map<String, dynamic>> _loadUsers() async {
    final raw = await storage.getString(CacheKeys.userCache);
    if (raw == null) return <String, dynamic>{};
    return dynParser<JsonMap>(jsonDecode(raw));
  }

  Future<Map<String, int>> _loadTimestamps() async {
    final raw = await storage.getString(CacheKeys.userCacheTimestamps);
    if (raw == null) return <String, int>{};
    final map = dynParser<JsonMap>(jsonDecode(raw));
    return map.map((k, v) => MapEntry(k, dynParser<int>(v)));
  }
}
