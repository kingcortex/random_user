import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:random_user/application/users/users_list_controller.dart';
import 'package:random_user/core/task/src/async_value.dart';
import 'package:random_user/core/utils/gap.dart';
import 'package:random_user/domain/entities/user.dart';
import 'package:random_user/presentation/common/widgets/custom_pagination_list.dart';
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
            return _ErrorView(
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            12.verticalSpace,
            Text(message, textAlign: TextAlign.center),
            16.verticalSpace,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
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
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.warning_amber, size: 20),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(onPressed: onRetry, child: const Text('Réessayer')),
            ],
          ),
        ),
      ),
    );
  }
}
