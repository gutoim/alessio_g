import 'package:dummy_shop/domain/entities/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

/// A product as returned by `GET /products` and `GET /products/{id}`.
///
/// Only the fields the app shows are read. The rest (reviews, dimensions,
/// meta, ...) are ignored.
@JsonSerializable(createToJson: false)
class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    this.images = const [],
    this.brand,
    this.availabilityStatus,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  final int id;
  final String title;
  final String description;
  final String category;

  // Sent as an integer for some products (e.g. `1` instead of `1.0`); the
  // generated parser reads any number as a double.
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;

  /// Missing for 92 of the 194 products.
  final String? brand;

  /// `In Stock`, `Low Stock` or `Out of Stock`.
  final String? availabilityStatus;

  Product toDomain() => Product(
    id: id,
    title: title,
    description: description,
    category: category,
    price: price,
    discountPercentage: discountPercentage,
    rating: rating,
    stock: stock,
    stockStatus: _stockStatus(),
    thumbnailUrl: thumbnail,
    imageUrls: images,
    brand: brand,
  );

  /// The API's own status is the source of truth: its thresholds overlap
  /// (a stock of 7 appears as both "In Stock" and "Low Stock"). The stock
  /// count is only a fallback for missing or unknown values.
  StockStatus _stockStatus() => switch (availabilityStatus) {
    'In Stock' => StockStatus.inStock,
    'Low Stock' => StockStatus.lowStock,
    'Out of Stock' => StockStatus.outOfStock,
    _ => stock > 0 ? StockStatus.inStock : StockStatus.outOfStock,
  };
}
