import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:random_user/core/network/api_endpoints.dart';

@module
abstract class DiExternal {
  static const Duration kHttpConnectTimeout = Duration(seconds: 30);
  static const Duration kHttpReceiveTimeout = Duration(seconds: 30);

  @lazySingleton
  @preResolve
  Future<SharedPreferences> get provideSharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  Dio provideDio() => Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.randomUserBaseUrl,
          connectTimeout: kHttpConnectTimeout,
          receiveTimeout: kHttpReceiveTimeout,
          responseType: ResponseType.json,
        ),
      );
}
