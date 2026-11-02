import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_detail_event.freezed.dart';

@freezed
sealed class ProductDetailEvent with _$ProductDetailEvent {
  /// Loads product [productId]: when the page opens, and on retry.
  const factory ProductDetailEvent.loadRequested(int productId) =
      ProductDetailLoadRequested;
}
