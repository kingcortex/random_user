import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:random_user/core/network/api_endpoints.dart';

@module
abstract class DiExternal {
  @lazySingleton
  @preResolve
  Future<SharedPreferences> get provideSharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  Dio provideDio() => Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );
}
