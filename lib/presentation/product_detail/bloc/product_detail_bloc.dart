import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/domain/use_cases/get_product_use_case.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  /// [preview] is the product as the list already had it. The bloc starts
  /// with it, so the page needs no spinner, and its very first frame already
  /// holds the gallery. Flutter picks the Heroes to fly from that frame: a
  /// preview emitted by an event arrives a frame too late.
  ProductDetailBloc(this._getProduct, {@factoryParam Product? preview})
    : super(
        preview == null
            ? const ProductDetailState.loading()
            : ProductDetailState.loaded(preview),
      ) {
    on<ProductDetailLoadRequested>(_onLoadRequested, transformer: droppable());
  }

  final GetProductUseCase _getProduct;

  /// Always fetches the product: opened from a deep link there is no preview,
  /// and opened from the list the fetch gets fresh data (stock and price may
  /// have changed).
  Future<void> _onLoadRequested(
    ProductDetailLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    // A retry after a failure. A preview stays on screen while loading.
    if (state is ProductDetailFailure) {
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
