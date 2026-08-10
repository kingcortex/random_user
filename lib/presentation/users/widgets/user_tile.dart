import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:random_user/core/routing/routes.dart';
import 'package:random_user/core/theme/sizes.dart';
import 'package:random_user/core/theme/spacing.dart';
import 'package:random_user/core/theme/text_theme.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/presentation/common/widgets/app_cached_image_network.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: Spacing.tileContent,
      leading: AppCachedImageNetwork(
        imageUrl: user.picture.medium,
        heroTag: user.id,
        width: Sizes.avatar,
        height: Sizes.avatar,
        shape: BoxShape.circle,
      ),
      title: Text(
        '${user.name.first} ${user.name.last}',
        style: context.titleMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.pushNamed(
        Routes.userDetails.name,
        pathParameters: {'id': user.id},
      ),
    );
  }
}
