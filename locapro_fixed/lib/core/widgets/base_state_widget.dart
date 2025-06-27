import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loading_widget.dart';
import 'error_widget.dart';

class BaseStateWidget<T> extends StatelessWidget {
  final AsyncValue<T> state;
  final Widget Function(T data) onData;
  final Widget Function()? onLoading;
  final Widget Function(dynamic error)? onError;
  final bool useLoadingGrid;
  final bool useLoadingList;

  const BaseStateWidget({
    super.key,
    required this.state,
    required this.onData,
    this.onLoading,
    this.onError,
    this.useLoadingGrid = false,
    this.useLoadingList = false,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      data: onData,
      loading: () => onLoading?.call() ?? _buildDefaultLoading(),
      error: (error, stackTrace) =>
          onError?.call(error) ?? _buildDefaultError(error),
    );
  }

  Widget _buildDefaultLoading() {
    if (useLoadingGrid) {
      return const LoadingGridWidget();
    } else if (useLoadingList) {
      return const LoadingListWidget();
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildDefaultError(dynamic error) {
    return CustomErrorWidget(
      error: error,
      onRetry: state is AsyncLoading ? null : () {
        if (state.hasError) {
          state.whenData((value) => value); // Trigger refresh
        }
      },
    );
  }
}