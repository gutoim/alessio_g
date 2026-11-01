import 'package:dummy_shop/data/models/product_dto.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response_dto.g.dart';

/// Response of `GET /products?skip=&limit=`.
@JsonSerializable(createToJson: false)
class ProductsResponseDto {
  const ProductsResponseDto({
    required this.products,
    required this.total,
    required this.skip,
  });

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseDtoFromJson(json);

  final List<ProductDto> products;
  final int total;
  final int skip;

  PaginatedProducts toDomain() => PaginatedProducts(
    items: [for (final product in products) product.toDomain()],
    skip: skip,
    total: total,
  );
}
