import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

enum StockStatus { inStock, lowStock, outOfStock }

@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required String description,

    /// Category slug, for example `beauty` or `mens-shirts`.
    required String category,

    /// List price, before [discountPercentage] is applied.
    required double price,
    required double discountPercentage,

    /// Average review score, 0 to 5.
    required double rating,
    required int stock,
    required StockStatus stockStatus,
    required String thumbnailUrl,
    required List<String> imageUrls,

    /// Not every product has one (groceries, for example).
    String? brand,
  }) = _Product;

  const Product._();

  bool get hasDiscount => discountPercentage > 0;

  /// [price] after the discount, rounded to cents.
  double get discountedPrice =>
      (price * (100 - discountPercentage)).roundToDouble() / 100;
}
