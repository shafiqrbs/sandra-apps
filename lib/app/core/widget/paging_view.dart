import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '/app/core/utils/debouncer.dart';
import '/app/core/values/app_values.dart';

///ignore: must_be_immutable
class PagingView extends StatelessWidget {
  final Widget child;
  final Function() onLoadNextPage;
  final Future<void> Function()? onRefresh;

  ScrollController? scrollController;

  late final _debouncer = Debouncer(milliseconds: 500);

  PagingView({
    required this.child,
    required this.onLoadNextPage,
    super.key,
    this.onRefresh,
    this.scrollController,
  }) {
    scrollController ??= ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollController != null) {
          final triggerFetchMoreSize =
              0.75 * scrollController!.position.maxScrollExtent;

          if (scrollController!.position.pixels >= triggerFetchMoreSize &&
              (scrollController!.position.userScrollDirection ==
                  ScrollDirection.reverse)) {
            _debouncer.run(onLoadNextPage);
          }
        }

        return true;
      },
      child: onRefresh == null
          ? _getScrollableView()
          : RefreshIndicator(
              onRefresh: onRefresh!,
              child: _getScrollableView(),
            ),
    );
  }

  SingleChildScrollView _getScrollableView() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          child,
          const SizedBox(
            height: AppValues.listBottomEmptySpace,
          ),
        ],
      ),
    );
  }
}
