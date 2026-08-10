import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:random_user/application/users/users_list_controller.dart';
import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/theme/sizes.dart';
import 'package:random_user/core/theme/spacing.dart';
import 'package:random_user/core/utils/gap.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/presentation/common/widgets/custom_pagination_list.dart';
import 'package:random_user/presentation/common/widgets/error_view.dart';
import 'package:random_user/presentation/users/widgets/user_tile.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: Consumer<UsersListController>(
        builder: (context, controller, _) {
          final state = controller.users;
          if ((state.status == Status.initial ||
                  state.status == Status.loading) &&
              controller.items.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state.status == Status.error && controller.items.isEmpty) {
            return ErrorView(
              message: state.message.displayMessage,
              onRetry: controller.loadInitial,
            );
          }
          return Column(
            children: [
              Expanded(
                child: CustomPaginationList<User>(
                  items: controller.items,
                  isLoadingMore: controller.isLoadingMore,
                  fetchMoreItems: controller.hasMore
                      ? controller.loadMore
                      : null,
                  onRefresh: controller.refresh,

                  itemBuilder: (context, user) => UserTile(user: user),
                ),
              ),
              if (controller.loadMoreError != null)
                _LoadMoreErrorBanner(
                  message: controller.loadMoreError!.message.displayMessage,
                  onRetry: controller.retryLoadMore,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LoadMoreErrorBanner extends StatelessWidget {
  const _LoadMoreErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: Spacing.bannerPadding,
        child: Row(
          children: [
            const Icon(Icons.warning_amber, size: Sizes.iconSm),
            8.horizontalSpace,
            Expanded(child: Text(message, overflow: TextOverflow.ellipsis)),
            TextButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}
