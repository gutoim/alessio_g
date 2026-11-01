import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/use_cases/get_products_use_case.dart';
import 'package:dummy_shop/presentation/products/bloc/products_event.dart';
import 'package:dummy_shop/presentation/products/bloc/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._getProducts) : super(const ProductsState.loading()) {
    on<ProductsLoadRequested>(_onLoadRequested, transformer: droppable());
    on<ProductsRefreshRequested>(_onRefreshRequested, transformer: droppable());
    // Scrolling fires this many times: one page request at a time.
    on<ProductsNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
  }

  final GetProductsUseCase _getProducts;

  /// Increased whenever the list is replaced from the first page. A next page
  /// that was requested before that belongs to the old list and is dropped.
  int _listVersion = 0;

  Future<void> _onLoadRequested(
    ProductsLoadRequested event,
    Emitter<ProductsState> emit,
  ) async {
    _listVersion++;
    // Bloc lets the very first emit through even when it equals the initial
    // state, so only switch to loading when coming from another state.
    if (state is! ProductsLoading) emit(const ProductsState.loading());

    final result = await _getProducts(skip: 0);

    emit(switch (result) {
      Ok(:final value) => ProductsState.loaded(
        products: value.items,
        hasMore: value.hasMore,
      ),
      Err(:final failure) => ProductsState.failure(failure),
    });
  }

  Future<void> _onRefreshRequested(
    ProductsRefreshRequested event,
    Emitter<ProductsState> emit,
  ) async {
    // Pull-to-refresh only exists while products are on screen.
    final current = state;
    if (current is! ProductsLoaded) return;

    // A refresh wins over a next page that is still loading: that page is
    // dropped when it arrives (see [_listVersion]).
    _listVersion++;
    final beforeRefresh = current.copyWith(
      isLoadingMore: false,
      loadMoreFailure: null,
      refreshFailure: null,
    );
    emit(beforeRefresh.copyWith(isRefreshing: true));

    final result = await _getProducts(skip: 0);

    emit(switch (result) {
      Ok(:final value) => ProductsState.loaded(
        products: value.items,
        hasMore: value.hasMore,
      ),
      Err(:final failure) => beforeRefresh.copyWith(refreshFailure: failure),
    });
  }

  Future<void> _onNextPageRequested(
    ProductsNextPageRequested event,
    Emitter<ProductsState> emit,
  ) async {
    final current = state;
    if (current is! ProductsLoaded ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.isRefreshing) {
      return;
    }

    final version = _listVersion;
    emit(current.copyWith(isLoadingMore: true, loadMoreFailure: null));

    final result = await _getProducts(skip: current.products.length);

    final latest = state;
    if (version != _listVersion || latest is! ProductsLoaded) return;

    emit(switch (result) {
      Ok(:final value) => latest.copyWith(
        products: [...latest.products, ...value.items],
        hasMore: value.hasMore,
        isLoadingMore: false,
      ),
      Err(:final failure) => latest.copyWith(
        isLoadingMore: false,
        loadMoreFailure: failure,
      ),
    });
  }
}
