import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:random_user/application/users/user_details_controller.dart';
import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/theme/sizes.dart';
import 'package:random_user/core/theme/spacing.dart';
import 'package:random_user/core/utils/gap.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/presentation/common/widgets/app_cached_image_network.dart';

class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails')),
      body: Consumer<UserDetailsController>(
        builder: (context, controller, _) {
          final state = controller.user;
          if (state.status == Status.initial || state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state.status == Status.error) {
            return Center(
              child: Padding(
                padding: Spacing.pagePadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message.displayMessage, textAlign: TextAlign.center),
                    16.verticalSpace,
                    ElevatedButton.icon(
                      onPressed: () => controller.load(userId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }
          return _DetailsBody(user: state.value!);
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: Spacing.pagePadding,
      children: [
        Center(
          child: AppCachedImageNetwork(
            imageUrl: user.picture.large,
            width: Sizes.profilePhoto,
            height: Sizes.profilePhoto,
            shape: BoxShape.circle,
          ),
        ),
        16.verticalSpace,
        Center(
          child: Text(
            '${user.name.first} ${user.name.last}',
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Center(
          child: Text(
            user.email,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        24.verticalSpace,
        _Section(
          icon: Icons.location_on_outlined,
          title: 'Adresse',
          value:
              '${user.location.street.number} ${user.location.street.name}\n'
              '${user.location.postcode} ${user.location.city}\n'
              '${user.location.state}, ${user.location.country}',
        ),
        _Section(
          icon: Icons.phone_outlined,
          title: 'Téléphone (fixe)',
          value: user.phone,
        ),
        _Section(
          icon: Icons.phone_iphone,
          title: 'Téléphone (mobile)',
          value: user.cell,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: Spacing.sectionVertical,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelLarge),
                4.verticalSpace,
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
