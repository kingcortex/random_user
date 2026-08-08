import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:random_user/core/routing/routes.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/presentation/common/widgets/app_cached_image_network.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: AppCachedImageNetwork(
        imageUrl: user.picture.medium,
        width: 56,
        height: 56,
        shape: BoxShape.circle,
      ),
      title: Text(
        '${user.name.first} ${user.name.last}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.pushNamed(
        Routes.userDetails.name,
        pathParameters: {'id': user.id},
      ),
    );
  }
}
