import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:random_user/application/users/user_details_controller.dart';
import 'package:random_user/application/users/users_list_controller.dart';
import 'package:random_user/core/di/injector.dart';
import 'package:random_user/core/routing/routes.dart';
import 'package:random_user/presentation/users/pages/user_details_page.dart';
import 'package:random_user/presentation/users/pages/users_list_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.usersList.name,
  routes: [
    GoRoute(
      path: Routes.usersList.path,
      name: Routes.usersList.name,
      builder: (context, state) => ChangeNotifierProvider<UsersListController>(
        create: (_) => sl<UsersListController>()..loadInitial(),
        child: const UsersListPage(),
      ),
    ),
    GoRoute(
      path: Routes.userDetails.path,
      name: Routes.userDetails.name,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChangeNotifierProvider<UserDetailsController>(
          create: (_) => sl<UserDetailsController>()..load(id),
          child: UserDetailsPage(userId: id),
        );
      },
    ),
  ],
);
