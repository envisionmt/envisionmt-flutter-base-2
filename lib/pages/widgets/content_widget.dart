import 'package:flutter/material.dart';

import 'empty_state_widget.dart';

enum DataSourceStatus { initial, loading, refreshing, empty, success, failed, loadMore }

typedef RefreshCallback = Future<void> Function(BuildContext context);

class ContentBundle extends StatefulWidget {
  ContentBundle({
    Key? key,
    required Widget child,
    required this.status,
    required this.onRefresh,
    this.onLoadMore,
    this.emptyEnable = true,
    this.emptyBackground = Colors.white,
    this.emptyTitle,
    this.emptyActionTitle,
    this.emptyAction,
    this.showCustomEmptyTitle = false,
  })  : child = _builderOrNull(child)!,
        super(key: key);

  final WidgetBuilder child;
  final DataSourceStatus? status;
  final RefreshCallback onRefresh;
  final RefreshCallback? onLoadMore;

  final bool emptyEnable;
  final Color emptyBackground;
  final String? emptyTitle;
  final String? emptyActionTitle;
  final Function(BuildContext)? emptyAction;
  final bool showCustomEmptyTitle;

  static WidgetBuilder? _builderOrNull(Widget? widget) {
    return widget == null ? null : ((_) => widget);
  }

  @override
  _ContentBundleState createState() => _ContentBundleState();
}

class _ContentBundleState extends State<ContentBundle> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: _buildContent(context),
      onNotification: (ScrollNotification value) => _onNotification(context, value),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (widget.status) {
      case DataSourceStatus.initial:
      case DataSourceStatus.loading:
        return _buildLoadingWidget();
      case DataSourceStatus.refreshing:
        return _buildRefreshingWidget(context);
      case DataSourceStatus.empty:
        return widget.emptyEnable ? _buildEmptyWidget(context) : Container();
      case DataSourceStatus.loadMore:
      case DataSourceStatus.success:
        return _buildSuccessWidget(context);
      case DataSourceStatus.failed:
      default:
        return _buildFailedWidget(context);
    }
  }

  Widget _buildFailedWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => widget.onRefresh(context),
      child: widget.emptyEnable ? _buildEmptyWidget(context) : Container(),
    );
  }

  Padding _buildSuccessWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => widget.onRefresh(context),
              child: widget.child(context),
            ),
          ),
          Visibility(
            visible: widget.status == DataSourceStatus.loadMore && widget.onLoadMore != null,
            child: Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.all(8),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: EmptyStateWidget(
        background: widget.emptyBackground,
        onActionTapped: widget.emptyAction,
        titleAction: widget.emptyActionTitle ?? 'Retry',
        title: widget.showCustomEmptyTitle ? widget.emptyTitle : null,
      ),
    );
  }

  Column _buildRefreshingWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        const LinearProgressIndicator(
          minHeight: 2.0,
        ),
        const SizedBox(height: 6.0),
        Expanded(child: widget.child(context)),
      ],
    );
  }

  Center _buildLoadingWidget() => const Center(child: CircularProgressIndicator());

  bool _onNotification(BuildContext context, ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      widget.onLoadMore?.call(context);
    }
    return true;
  }
}
