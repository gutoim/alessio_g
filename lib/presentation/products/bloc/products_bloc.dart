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
  }

  final GetProductsUseCase _getProducts;

  Future<void> _onLoadRequested(
    ProductsLoadRequested event,
    Emitter<ProductsState> emit,
  ) async {
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

    emit(current.copyWith(isRefreshing: true, refreshFailure: null));

    final result = await _getProducts(skip: 0);

    emit(switch (result) {
      Ok(:final value) => ProductsState.loaded(
        products: value.items,
        hasMore: value.hasMore,
      ),
      Err(:final failure) => current.copyWith(refreshFailure: failure),
    });
  }
}
