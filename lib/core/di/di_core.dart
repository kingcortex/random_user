import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:random_user/core/network/client.dart';
import 'package:random_user/core/storage/app_storage.dart';

@module
abstract class DiCoreModule {
  @lazySingleton
  AppPreferencesStorage provideAppPreferencesStorage(SharedPreferences prefs) =>
      AppPreferencesStorageImpl(sharedPreferences: prefs);

  @lazySingleton
  HttpClient provideHttpClient(Dio dio) => HttpClientImpl(dio: dio);
}
