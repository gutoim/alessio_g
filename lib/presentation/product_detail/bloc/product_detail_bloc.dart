import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/use_cases/get_product_use_case.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc(this._getProduct)
    : super(const ProductDetailState.loading()) {
    on<ProductDetailLoadRequested>(_onLoadRequested, transformer: droppable());
  }

  final GetProductUseCase _getProduct;

  /// Shows the preview at once, if there is one, then always fetches the
  /// product: opened from a deep link there is no preview, and opened from
  /// the list the fetch gets fresh data (stock and price may have changed).
  Future<void> _onLoadRequested(
    ProductDetailLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    final preview = event.preview;
    if (preview != null && preview.id == event.productId) {
      emit(ProductDetailState.loaded(preview));
    } else if (state is! ProductDetailLoading) {
      // Bloc lets the very first emit through even when it equals the
      // initial state, so only switch to loading from another state.
      emit(const ProductDetailState.loading());
    }

    final result = await _getProduct(event.productId);

    switch (result) {
      case Ok(:final value):
        emit(ProductDetailState.loaded(value));
      case Err(:final failure):
        // A preview on screen is more useful than an error page.
        if (state is! ProductDetailLoaded) {
          emit(ProductDetailState.failure(failure));
        }
    }
  }
}
