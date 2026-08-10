import 'package:flutter/material.dart';

import 'package:random_user/core/theme/spacing.dart';
import 'package:random_user/core/utils/gap.dart';

class CustomPaginationList<T> extends StatefulWidget {
  final Widget Function(BuildContext context, T item) itemBuilder;
  final List<T> items;
  final Widget? loadingWidget;
  final ScrollController? scrollController;
  final VoidCallback? fetchMoreItems;
  final bool Function(ScrollNotification)? onNotification;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Future<void> Function() onRefresh;
  final bool isLoadingMore;

  const CustomPaginationList({
    super.key,
    required this.itemBuilder,
    this.loadingWidget,
    this.scrollController,
    this.onNotification,
    this.shrinkWrap = false,
    this.physics,
    required this.items,
    required this.isLoadingMore,
    this.fetchMoreItems,
    required this.onRefresh,
  });

  @override
  State<CustomPaginationList<T>> createState() =>
      _CustomPaginationListState<T>();
}

class _CustomPaginationListState<T> extends State<CustomPaginationList<T>> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (widget.onNotification?.call(notification) ?? false) {
          return true;
        }
        if (notification is ScrollEndNotification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            widget.fetchMoreItems?.call();
            return true;
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await widget.onRefresh();
        },
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      controller: widget.scrollController,
      itemCount: widget.items.length + 1,
      itemBuilder: (context, index) {
        if (index < widget.items.length) {
          return widget.itemBuilder(context, widget.items[index]);
        } else if (widget.isLoadingMore) {
          return widget.loadingWidget ?? CircularProgressIndicator.adaptive();
        } else {
          return SizedBox.shrink();
        }
      },
      separatorBuilder: (context, index) => Spacing.sm.verticalSpace,
      padding: Spacing.pagePadding.copyWith(bottom: 100),
    );
  }
}
