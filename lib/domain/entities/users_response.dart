import 'package:equatable/equatable.dart';

import 'page_info.dart';
import 'user.dart';

final class UsersResponse extends Equatable {
  const UsersResponse({required this.users, required this.info});

  final List<User> users;
  final PageInfo info;

  @override
  List<Object?> get props => [users, info];
}
