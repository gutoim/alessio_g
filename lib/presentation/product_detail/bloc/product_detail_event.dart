import 'package:dummy_shop/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_detail_event.freezed.dart';

@freezed
sealed class ProductDetailEvent with _$ProductDetailEvent {
  /// Loads product [productId]: when the page opens, and on retry.
  ///
  /// [preview] is the product as the list already had it. It is shown at
  /// once, so the page needs no spinner and the image can fly in as a Hero.
  const factory ProductDetailEvent.loadRequested(
    int productId, {
    Product? preview,
  }) = ProductDetailLoadRequested;
}
