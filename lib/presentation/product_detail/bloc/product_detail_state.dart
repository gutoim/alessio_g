import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_detail_state.freezed.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.loading() = ProductDetailLoading;

  const factory ProductDetailState.failure(Failure failure) =
      ProductDetailFailure;

  const factory ProductDetailState.loaded(Product product) =
      ProductDetailLoaded;
}
