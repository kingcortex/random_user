import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:random_user/application/users/user_details_controller.dart';
import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/theme/app_colors.dart';
import 'package:random_user/core/theme/sizes.dart';
import 'package:random_user/core/theme/spacing.dart';
import 'package:random_user/core/utils/gap.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/presentation/common/widgets/app_cached_image_network.dart';

import '../../../core/theme/text_theme.dart';

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
          if (state.status == Status.initial ||
              state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state.status == Status.error) {
            return Center(
              child: Padding(
                padding: Spacing.pagePadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message.displayMessage,
                      textAlign: TextAlign.center,
                    ),
                    Spacing.md.verticalSpace,
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
    return ListView(
      padding: Spacing.pagePadding,
      children: [
        Center(
          child: AppCachedImageNetwork(
            heroTag: user.id,
            imageUrl: user.picture.large,
            width: Sizes.profilePhoto,
            height: Sizes.profilePhoto,
            shape: BoxShape.circle,
          ),
        ),
        Spacing.md.verticalSpace,
        Center(
          child: Text(
            '${user.name.first} ${user.name.last}',
            style: context.headlineSmall,
          ),
        ),
        Center(child: Text(user.email, style: context.bodyMedium)),
        Spacing.xl.verticalSpace,
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
  const _Section({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Spacing.sectionVertical,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.primary),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacing.xxs.verticalSpace,
                Text(value, style: context.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
