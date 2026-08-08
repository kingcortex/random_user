import 'package:flutter/material.dart';

import 'package:random_user/app/app.dart';
import 'package:random_user/core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
