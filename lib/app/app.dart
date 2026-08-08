import 'package:flutter/material.dart';

import 'package:random_user/core/routing/app_router.dart';
import 'package:random_user/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Random User',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
