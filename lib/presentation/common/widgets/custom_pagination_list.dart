import 'package:flutter/material.dart';

import '../../../../core/utils/app_constant.dart';
import '../../../core/utils/gap.dart';

class CustomPaginationList<T> extends StatefulWidget {
  final Widget Function(BuildContext context, T item) itemBuilder;
  final List<T> items;
  final Widget? loadingWidget;
  final int pageSize;
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
    this.pageSize = 50,
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
  void initState() {
    super.initState();
  }

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
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          await widget.onRefresh();
        },
        child: _buidList(),
      ),
    );
  }

  Widget _buidList() {
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
      separatorBuilder: (context, index) => 12.verticalSpace,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstant.appPadding,
      ).copyWith(bottom: 100),
    );
  }
}
