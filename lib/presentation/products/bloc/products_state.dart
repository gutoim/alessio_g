import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_state.freezed.dart';

@freezed
sealed class ProductsState with _$ProductsState {
  /// The first page is loading. Nothing to show yet.
  const factory ProductsState.loading() = ProductsLoading;

  /// The first page failed. Nothing to show but the error and a retry.
  const factory ProductsState.failure(Failure failure) = ProductsFailure;

  /// Products are on screen. An empty [products] list is the empty state.
  const factory ProductsState.loaded({
    required List<Product> products,
    required bool hasMore,

    /// A pull-to-refresh is running. The current list stays visible.
    @Default(false) bool isRefreshing,

    /// The last pull-to-refresh failed. The list is kept and the error is
    /// shown once, as a snackbar.
    Failure? refreshFailure,

    /// The next page is loading. Shown as a spinner at the end of the list.
    @Default(false) bool isLoadingMore,

    /// Loading the next page failed. Shown at the end of the list with a
    /// retry; scrolling does not retry on its own.
    Failure? loadMoreFailure,
  }) = ProductsLoaded;
}
