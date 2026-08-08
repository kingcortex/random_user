class Route {
  const Route({required this.name, required this.path});
  final String name;
  final String path;
}

class Routes {
  Routes._();

  static const Route usersList = Route(name: 'users_list', path: '/');

  static const Route userDetails = Route(
    name: 'user_details',
    path: '/user/:id',
  );
}
